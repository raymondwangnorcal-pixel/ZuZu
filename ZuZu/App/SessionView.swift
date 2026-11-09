import SwiftUI
import Vision

struct SessionView: View {
    @EnvironmentObject private var workout: WorkoutController
    @EnvironmentObject private var store: SessionStore
    @StateObject private var camera = CameraPoseTracker()
    @State private var showingStop = false
    @State private var resumeAfterStop = false

    private var remaining: Int { max(0, workout.target - workout.count) }

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                header
                counter
                feedback
                if workout.mode == .camera { cameraRecovery }
                if workout.mode == .camera { posePanel } else { tapPanel }
                raceCard
                controls
                bottomStatus
            }
            .padding(.horizontal, 20)
            .padding(.top, 14)
            .padding(.bottom, 22)
        }
        .background(ZuZuTheme.background)
        .confirmationDialog("End this session?", isPresented: $showingStop) {
            if workout.count > 0 {
                Button("Save \(workout.count) reps") { saveSession() }
            }
            Button("Discard session", role: .destructive) { workout.discard() }
            Button("Keep going", role: .cancel) {
                if resumeAfterStop { workout.resume() }
            }
        } message: {
            Text(workout.count == workout.target
                 ? "Save this completed goal or discard the session."
                 : "Saved partial sessions add reps to Progress but do not earn a streak day.")
        }
        .alert("Couldn’t save session", isPresented: Binding(
            get: { store.storageError != nil },
            set: { if !$0 { store.storageError = nil } }
        )) { Button("OK") { store.storageError = nil } } message: {
            Text(store.storageError ?? "Please try again.")
        }
        .onAppear {
            camera.onRep = { [weak workout] in workout?.acceptCameraRep() }
            camera.onStatus = { [weak workout] status in
                workout?.cameraStatus = status
                if status == .interrupted || status == .unavailable || status == .denied {
                    workout?.pauseForInterruption()
                }
            }
            syncCamera()
        }
        .onDisappear { camera.stop() }
        .onChange(of: workout.phase) { _, _ in syncCamera() }
        .onChange(of: workout.mode) { _, _ in syncCamera() }
    }

    private var header: some View {
        HStack {
            Button {
                resumeAfterStop = workout.phase == .active
                workout.pause()
                showingStop = true
            } label: {
                Image(systemName: "xmark")
                    .font(.headline)
                    .frame(width: 42, height: 42)
                    .background(ZuZuTheme.raised, in: Circle())
            }
            .accessibilityLabel("End session")
            Spacer()
            Text("PUSHUP SESSION")
                .font(.caption.weight(.bold))
                .tracking(1.5)
                .foregroundStyle(ZuZuTheme.muted)
            Spacer()
            Text("\(workout.count)/\(workout.target)")
                .font(.subheadline.weight(.bold).monospacedDigit())
                .foregroundStyle(ZuZuTheme.amber)
                .frame(minWidth: 50, alignment: .trailing)
        }
    }

    private var counter: some View {
        ZStack {
            Circle().stroke(ZuZuTheme.raised, lineWidth: 17)
            Circle()
                .trim(from: 0, to: CGFloat(workout.count) / CGFloat(max(1, workout.target)))
                .stroke(ZuZuTheme.coral, style: StrokeStyle(lineWidth: 17, lineCap: .round))
                .rotationEffect(.degrees(-90))
            VStack(spacing: 0) {
                Text("\(workout.count)")
                    .font(.system(size: 90, weight: .bold, design: .rounded))
                    .contentTransition(.numericText())
                Text("OF \(workout.target) PUSHUPS")
                    .font(.caption.weight(.bold))
                    .tracking(1.5)
                    .foregroundStyle(ZuZuTheme.muted)
            }
        }
        .frame(width: 230, height: 230)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(workout.count) of \(workout.target) pushups")
    }

    private var feedback: some View {
        HStack(spacing: 7) {
            Image(systemName: feedbackIcon)
            Text(feedbackText)
        }
        .font(.subheadline.weight(.semibold))
        .foregroundStyle(feedbackColor)
        .padding(.horizontal, 15)
        .padding(.vertical, 9)
        .background(feedbackColor.opacity(0.15), in: Capsule())
    }

    private var feedbackIcon: String {
        if workout.phase == .goalReview { return "checkmark.circle.fill" }
        if workout.phase == .paused { return "pause.fill" }
        if workout.mode == .tap { return "hand.tap.fill" }
        switch workout.cameraStatus {
        case .uncertain: return "exclamationmark.triangle.fill"
        case .outOfFrame, .interrupted, .denied, .unavailable: return "camera.fill"
        default: return "checkmark.circle.fill"
        }
    }

    private var feedbackText: String {
        if workout.phase == .goalReview { return "Goal complete" }
        if workout.phase == .paused { return "Paused" }
        if workout.mode == .tap { return "Tap each completed rep" }
        switch workout.cameraStatus {
        case .uncertain: return "Check count"
        case .outOfFrame: return "Move into frame"
        case .interrupted: return "Camera interrupted"
        case .denied: return "Camera access is off"
        case .unavailable: return "Camera unavailable"
        case .requesting: return "Starting camera"
        default: return "Camera counting"
        }
    }

    private var feedbackColor: Color {
        guard workout.mode == .camera else { return ZuZuTheme.mint }
        switch workout.cameraStatus {
        case .uncertain, .outOfFrame, .interrupted, .denied, .unavailable:
            return ZuZuTheme.amber
        default: return ZuZuTheme.mint
        }
    }

    @ViewBuilder
    private var cameraRecovery: some View {
        if workout.cameraStatus == .interrupted || workout.cameraStatus == .unavailable
            || workout.cameraStatus == .denied {
            VStack(alignment: .leading, spacing: 9) {
                Text(workout.cameraStatus == .interrupted
                     ? "The camera was interrupted. Resume when it is available, or switch to tap counting."
                     : "Camera counting is unavailable. Switch to tap counting to continue this session.")
                    .font(.subheadline)
                    .foregroundStyle(ZuZuTheme.muted)
                if workout.cameraStatus == .denied {
                    Button("Open camera settings") {
                        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                        UIApplication.shared.open(url)
                    }
                    .font(.subheadline.weight(.semibold))
                }
            }
            .zuzuCard(radius: 18)
        }
    }

    private var posePanel: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24).fill(ZuZuTheme.card)
            if let skeleton = camera.skeleton {
                Canvas { context, size in
                    let links: [(VNHumanBodyPoseObservation.JointName, VNHumanBodyPoseObservation.JointName)] = [
                        (.leftShoulder, .leftElbow), (.leftElbow, .leftWrist),
                        (.rightShoulder, .rightElbow), (.rightElbow, .rightWrist),
                        (.leftShoulder, .rightShoulder), (.leftShoulder, .leftHip),
                        (.rightShoulder, .rightHip)
                    ]
                    for (a, b) in links {
                        guard let p1 = skeleton.joints[a], let p2 = skeleton.joints[b] else { continue }
                        var path = Path()
                        path.move(to: CGPoint(x: p1.x * size.width, y: (1 - p1.y) * size.height))
                        path.addLine(to: CGPoint(x: p2.x * size.width, y: (1 - p2.y) * size.height))
                        context.stroke(path, with: .color(ZuZuTheme.mint), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    }
                }
                .padding(25)
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 48, weight: .ultraLight))
                        .foregroundStyle(ZuZuTheme.mint)
                    Text("Keep your arms visible to the front camera")
                        .font(.footnote)
                        .foregroundStyle(ZuZuTheme.muted)
                }
            }
        }
        .frame(height: 126)
        .accessibilityLabel("Camera pose guide")
    }

    private var tapPanel: some View {
        Button { workout.acceptTapRep() } label: {
            Label("Tap for a rep", systemImage: "hand.tap.fill")
                .font(.title3.weight(.bold))
                .frame(maxWidth: .infinity)
                .frame(height: 126)
                .background(ZuZuTheme.card, in: RoundedRectangle(cornerRadius: 24))
        }
        .disabled(workout.phase != .active)
    }

    private var raceCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Snoozy is with you")
                    .font(.subheadline.weight(.bold))
                Spacer()
                Text("\(workout.count)/\(workout.target)")
                    .font(.caption)
                    .foregroundStyle(ZuZuTheme.muted)
            }
            GeometryReader { geometry in
                let fraction = CGFloat(workout.count) / CGFloat(max(1, workout.target))
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(ZuZuTheme.raised)
                        .frame(height: 8)
                        .padding(.horizontal, 18)
                    Capsule()
                        .fill(ZuZuTheme.amber)
                        .frame(width: fraction * (geometry.size.width - 36), height: 8)
                        .padding(.leading, 18)
                    Text("🦥")
                        .font(.system(size: 27))
                        .offset(x: fraction * (geometry.size.width - 36))
                    Image(systemName: "flag.checkered")
                        .font(.caption)
                        .foregroundStyle(ZuZuTheme.amber)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(height: 42)
            }
            .frame(height: 42)
        }
        .zuzuCard(radius: 18)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Snoozy is with you, \(workout.count) of \(workout.target) reps")
    }

    private var controls: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button { workout.correct(by: -1) } label: { Label("−1", systemImage: "minus") }
                    .disabled(workout.count == 0)
                Button { workout.correct(by: 1) } label: { Label("+1", systemImage: "plus") }
                    .disabled(workout.count == workout.target)
            }
            .buttonStyle(SecondarySessionButtonStyle())
            if workout.phase == .goalReview {
                Button("Done — save session") { saveSession() }
                    .buttonStyle(PrimarySessionButtonStyle())
            } else {
                HStack(spacing: 12) {
                    Button(workout.phase == .paused ? "Resume" : "Pause") {
                        if workout.phase == .paused { workout.resume() } else { workout.pause() }
                    }
                    .buttonStyle(SecondarySessionButtonStyle())
                    Button(workout.mode == .camera ? "Use tap count" : "Use camera") {
                        workout.switchMode(workout.mode == .camera ? .tap : .camera)
                    }
                    .buttonStyle(SecondarySessionButtonStyle())
                }
            }
        }
    }

    private var bottomStatus: some View {
        TimelineView(.periodic(from: .now, by: 1)) { timeline in
            HStack {
                Text("\(remaining) reps to goal")
                Spacer()
                Text(duration(workout.elapsed(at: timeline.date)))
                    .monospacedDigit()
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(ZuZuTheme.muted)
        }
    }

    private func duration(_ seconds: TimeInterval) -> String {
        let whole = Int(seconds)
        return String(format: "%d:%02d", whole / 60, whole % 60)
    }

    private func syncCamera() {
        if workout.phase == .active && workout.mode == .camera { camera.start() }
        else { camera.stop() }
    }

    private func saveSession() { _ = workout.save(into: store) }
}

private struct SecondarySessionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.bold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .foregroundStyle(ZuZuTheme.primary)
            .background(ZuZuTheme.raised.opacity(configuration.isPressed ? 0.7 : 1), in: RoundedRectangle(cornerRadius: 14))
    }
}

private struct PrimarySessionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .foregroundStyle(.black)
            .background(ZuZuTheme.amber, in: RoundedRectangle(cornerRadius: 16))
    }
}
