import Foundation
import Combine

enum CountMode: String {
    case camera
    case tap
}

enum WorkoutPhase: Equatable {
    case idle
    case setup
    case active
    case paused
    case goalReview
    case completed
}

@MainActor
final class WorkoutController: ObservableObject {
    @Published var phase: WorkoutPhase = .idle
    @Published var mode: CountMode = .camera
    @Published private(set) var target = 15
    @Published private(set) var count = 0
    @Published private(set) var cameraReps = 0
    @Published private(set) var tapReps = 0
    @Published private(set) var correctionDelta = 0
    @Published var cameraStatus: CameraStatus = .notStarted
    @Published var savedRecord: SessionRecord?
    @Published var earnedNewStreakDay = false

    private var startedAt = Date()
    private var accumulatedSeconds: TimeInterval = 0
    private var runningSince: Date?
    private var sessionID = UUID()

    func prepare(target: Int) {
        self.target = min(100, max(5, target))
        count = 0
        cameraReps = 0
        tapReps = 0
        correctionDelta = 0
        mode = .camera
        cameraStatus = .notStarted
        savedRecord = nil
        earnedNewStreakDay = false
        startedAt = Date()
        accumulatedSeconds = 0
        runningSince = nil
        sessionID = UUID()
        phase = .setup
    }

    func begin(mode: CountMode) {
        self.mode = mode
        startedAt = Date()
        runningSince = Date()
        phase = .active
    }

    func pause() {
        guard phase == .active else { return }
        freezeClock()
        phase = .paused
    }

    func pauseForInterruption() { pause() }

    func resume() {
        guard phase == .paused else { return }
        runningSince = Date()
        phase = .active
    }

    func switchMode(_ newMode: CountMode) {
        guard phase == .active || phase == .paused else { return }
        mode = newMode
        cameraStatus = .notStarted
    }

    func acceptCameraRep() { accept(.camera) }
    func acceptTapRep() { accept(.tap) }

    private func accept(_ source: CountMode) {
        guard phase == .active, mode == source, count < target else { return }
        count += 1
        if source == .camera { cameraReps += 1 } else { tapReps += 1 }
        if count == target {
            freezeClock()
            phase = .goalReview
        }
    }

    func correct(by delta: Int) {
        guard phase == .active || phase == .paused || phase == .goalReview else { return }
        let revised = min(target, max(0, count + delta))
        guard revised != count else { return }
        correctionDelta += revised - count
        count = revised
        if phase == .goalReview && count < target {
            phase = .paused
        } else if (phase == .active || phase == .paused) && count == target {
            freezeClock()
            phase = .goalReview
        }
    }

    func elapsed(at date: Date = Date()) -> TimeInterval {
        accumulatedSeconds + (runningSince.map { max(0, date.timeIntervalSince($0)) } ?? 0)
    }

    func save(into store: SessionStore) -> Bool {
        guard phase == .goalReview || phase == .active || phase == .paused else { return false }
        guard count > 0 else { return false }
        let now = Date()
        let finalElapsed = elapsed(at: now)
        let isComplete = count == target
        let record = SessionRecord(
            id: sessionID, target: target, acceptedReps: count,
            cameraReps: cameraReps, tapReps: tapReps, correctionDelta: correctionDelta,
            startedAt: startedAt, endedAt: now, elapsedSeconds: finalElapsed,
            outcome: isComplete ? .completed : .savedPartial
        )
        let alreadyCompletedToday = store.hasCompletedGoal(on: now)
        guard store.save(record) else { return false }
        freezeClock()
        savedRecord = record
        earnedNewStreakDay = isComplete && !alreadyCompletedToday
        phase = .completed
        return true
    }

    func discard() {
        freezeClock()
        savedRecord = nil
        phase = .idle
    }

    func finish() { phase = .idle }

    private func freezeClock() {
        if let runningSince {
            accumulatedSeconds += max(0, Date().timeIntervalSince(runningSince))
            self.runningSince = nil
        }
    }
}
