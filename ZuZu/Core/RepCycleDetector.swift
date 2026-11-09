import Foundation

/// Counts a bend followed by a return to the observed up position.
/// The angle is measured at the elbow in degrees; no fixed depth rule is imposed.
public struct RepCycleDetector: Sendable {
    private enum Phase: Sendable { case seekingUp, up, down }
    private var phase: Phase = .seekingUp
    private var upReference: Double = 0
    private var downFrames = 0
    private var upFrames = 0
    private var lastCountAt: TimeInterval = -.infinity

    public init() {}

    public mutating func reset() {
        self = RepCycleDetector()
    }

    public mutating func observe(elbowAngle: Double?, at time: TimeInterval) -> Bool {
        guard let angle = elbowAngle, angle.isFinite else {
            // An interrupted pose cannot prove that the observed down position
            // returned to up. Require a fresh complete cycle after reacquisition.
            phase = .seekingUp
            downFrames = 0
            upFrames = 0
            return false
        }
        switch phase {
        case .seekingUp:
            if angle >= 135 {
                upFrames += 1
                if upFrames >= 2 {
                    upReference = angle
                    phase = .up
                    upFrames = 0
                }
            } else { upFrames = 0 }
        case .up:
            upReference = max(upReference, angle)
            if angle <= upReference - 28 {
                downFrames += 1
                if downFrames >= 2 {
                    phase = .down
                    downFrames = 0
                }
            } else { downFrames = 0 }
        case .down:
            if angle >= upReference - 12 {
                upFrames += 1
                if upFrames >= 2 {
                    phase = .up
                    upFrames = 0
                    if time - lastCountAt >= 0.4 {
                        lastCountAt = time
                        return true
                    }
                }
            } else { upFrames = 0 }
        }
        return false
    }
}
