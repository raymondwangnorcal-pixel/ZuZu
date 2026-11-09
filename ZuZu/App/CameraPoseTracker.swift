import AVFoundation
import Combine
import Foundation
import ImageIO
import Vision

enum CameraStatus: Equatable {
    case notStarted
    case requesting
    case ready
    case uncertain
    case outOfFrame
    case interrupted
    case denied
    case unavailable
}

struct PoseSkeleton {
    let joints: [VNHumanBodyPoseObservation.JointName: CGPoint]
}

/// Frames are used only in memory. This class never creates a movie or photo output.
final class CameraPoseTracker: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published private(set) var status: CameraStatus = .notStarted
    @Published private(set) var skeleton: PoseSkeleton?

    var onRep: (() -> Void)?
    var onStatus: ((CameraStatus) -> Void)?

    private let session = AVCaptureSession()
    private let queue = DispatchQueue(label: "com.gaplesslabs.zuzu.camera")
    private var detector = RepCycleDetector()
    private let generationLock = NSLock()
    private var generation = 0
    private var lastFrameAt: TimeInterval = 0
    private var lastBodyAt: TimeInterval = 0
    private var isConfigured = false
    private var isRunning = false
    private var interruptionObserver: NSObjectProtocol?
    private var runtimeErrorObserver: NSObjectProtocol?

    override init() {
        super.init()
        interruptionObserver = NotificationCenter.default.addObserver(
            forName: AVCaptureSession.wasInterruptedNotification, object: session, queue: nil
        ) { [weak self] _ in self?.handleCaptureFailure(.interrupted) }
        runtimeErrorObserver = NotificationCenter.default.addObserver(
            forName: AVCaptureSession.runtimeErrorNotification, object: session, queue: nil
        ) { [weak self] _ in self?.handleCaptureFailure(.unavailable) }
    }

    deinit {
        if let interruptionObserver { NotificationCenter.default.removeObserver(interruptionObserver) }
        if let runtimeErrorObserver { NotificationCenter.default.removeObserver(runtimeErrorObserver) }
    }

    static var hasFrontCamera: Bool { frontCamera() != nil }

    private static func frontCamera() -> AVCaptureDevice? {
        if let wide = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            return wide
        }
        // A front video device is sufficient; depth hardware is optional.
        return AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInTrueDepthCamera],
            mediaType: .video, position: .front
        ).devices.first
    }

    func start() {
        publish(.requesting)
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            startAuthorized()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] allowed in
                guard let self else { return }
                if allowed { self.startAuthorized() } else { self.publish(.denied) }
            }
        case .denied, .restricted:
            publish(.denied)
        @unknown default:
            publish(.unavailable)
        }
    }

    func stop() {
        queue.async { [weak self] in
            guard let self else { return }
            self.advanceGeneration()
            self.isRunning = false
            self.detector.reset()
            if self.session.isRunning { self.session.stopRunning() }
            DispatchQueue.main.async { self.skeleton = nil }
        }
    }

    private func handleCaptureFailure(_ failure: CameraStatus) {
        queue.async { [weak self] in
            guard let self, self.isRunning else { return }
            self.advanceGeneration()
            self.isRunning = false
            self.detector.reset()
            self.publish(failure)
            DispatchQueue.main.async { [weak self] in self?.skeleton = nil }
        }
    }

    private func startAuthorized() {
        queue.async { [weak self] in
            guard let self else { return }
            if !self.isConfigured && !self.configure() {
                self.publish(.unavailable)
                return
            }
            self.advanceGeneration()
            self.detector.reset()
            self.lastBodyAt = ProcessInfo.processInfo.systemUptime
            self.isRunning = true
            if !self.session.isRunning { self.session.startRunning() }
            self.publish(self.session.isRunning ? .ready : .unavailable)
            if !self.session.isRunning { self.isRunning = false }
        }
    }

    private func configure() -> Bool {
        session.beginConfiguration()
        defer { session.commitConfiguration() }
        guard let device = Self.frontCamera(),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else { return false }
        session.addInput(input)
        guard let preset = [AVCaptureSession.Preset.medium, .vga640x480, .low]
            .first(where: { session.canSetSessionPreset($0) }) else {
            session.removeInput(input)
            return false
        }
        session.sessionPreset = preset
        let output = AVCaptureVideoDataOutput()
        output.alwaysDiscardsLateVideoFrames = true
        // Keep the camera's native pixel format to avoid a costly conversion on older iPhones.
        guard session.canAddOutput(output) else {
            session.removeInput(input)
            return false
        }
        session.addOutput(output)
        output.setSampleBufferDelegate(self, queue: queue)
        isConfigured = true
        return true
    }

    func captureOutput(
        _ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard isRunning else { return }
        let now = ProcessInfo.processInfo.systemUptime
        guard now - lastFrameAt >= 0.09 else { return }
        lastFrameAt = now
        let frameGeneration = currentGeneration()
        let request = VNDetectHumanBodyPoseRequest()
        let handler = VNImageRequestHandler(
            cmSampleBuffer: sampleBuffer, orientation: .leftMirrored, options: [:]
        )
        do {
            try handler.perform([request])
            guard frameGeneration == currentGeneration(), isRunning else { return }
            guard let observation = request.results?.first else {
                updateNoBody(at: now)
                return
            }
            let joints = recognizedJoints(in: observation)
            guard !joints.isEmpty else {
                updateNoBody(at: now)
                return
            }
            lastBodyAt = now
            let angle = elbowAngle(in: joints)
            publish(angle == nil ? .uncertain : .ready)
            DispatchQueue.main.async { [weak self] in
                guard let self, frameGeneration == self.currentGeneration() else { return }
                self.skeleton = PoseSkeleton(joints: joints)
            }
            if detector.observe(elbowAngle: angle, at: now) {
                DispatchQueue.main.async { [weak self] in
                    guard let self, frameGeneration == self.currentGeneration() else { return }
                    self.onRep?()
                }
            }
        } catch {
            _ = detector.observe(elbowAngle: nil, at: now)
            publish(.uncertain)
        }
    }

    private func updateNoBody(at now: TimeInterval) {
        _ = detector.observe(elbowAngle: nil, at: now)
        if now - lastBodyAt > 1.5 {
            publish(.outOfFrame)
            DispatchQueue.main.async { [weak self] in self?.skeleton = nil }
        } else {
            publish(.uncertain)
        }
    }

    private func recognizedJoints(
        in observation: VNHumanBodyPoseObservation
    ) -> [VNHumanBodyPoseObservation.JointName: CGPoint] {
        let names: [VNHumanBodyPoseObservation.JointName] = [
            .leftShoulder, .leftElbow, .leftWrist,
            .rightShoulder, .rightElbow, .rightWrist,
            .neck, .root, .leftHip, .rightHip
        ]
        var result: [VNHumanBodyPoseObservation.JointName: CGPoint] = [:]
        for name in names {
            guard let point = try? observation.recognizedPoint(name), point.confidence >= 0.35 else { continue }
            result[name] = point.location
        }
        return result
    }

    private func elbowAngle(
        in points: [VNHumanBodyPoseObservation.JointName: CGPoint]
    ) -> Double? {
        let sides: [(
            VNHumanBodyPoseObservation.JointName,
            VNHumanBodyPoseObservation.JointName,
            VNHumanBodyPoseObservation.JointName
        )] = [
            (.leftShoulder, .leftElbow, .leftWrist),
            (.rightShoulder, .rightElbow, .rightWrist)
        ]
        let angles = sides.compactMap { shoulder, elbow, wrist -> Double? in
            guard let a = points[shoulder], let b = points[elbow], let c = points[wrist] else { return nil }
            let ab = CGVector(dx: a.x - b.x, dy: a.y - b.y)
            let cb = CGVector(dx: c.x - b.x, dy: c.y - b.y)
            let product = ab.dx * cb.dx + ab.dy * cb.dy
            let magnitude = hypot(ab.dx, ab.dy) * hypot(cb.dx, cb.dy)
            guard magnitude > 0.0001 else { return nil }
            let cosine = Double(max(-1, min(1, product / magnitude)))
            return Foundation.acos(cosine) * 180 / Double.pi
        }
        guard !angles.isEmpty else { return nil }
        return angles.reduce(0, +) / Double(angles.count)
    }

    private func publish(_ next: CameraStatus) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if self.status != next {
                self.status = next
                self.onStatus?(next)
            }
        }
    }

    @discardableResult
    private func advanceGeneration() -> Int {
        generationLock.lock()
        defer { generationLock.unlock() }
        generation += 1
        return generation
    }

    private func currentGeneration() -> Int {
        generationLock.lock()
        defer { generationLock.unlock() }
        return generation
    }
}
