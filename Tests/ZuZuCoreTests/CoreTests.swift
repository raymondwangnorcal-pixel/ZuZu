import XCTest
@testable import ZuZuCore

final class CoreTests: XCTestCase {
    func testRepRequiresDownAndReturnToUp() {
        var detector = RepCycleDetector()
        let angles: [Double] = [158, 160, 145, 124, 119, 110, 120, 145, 156, 159]
        let counts = angles.enumerated().filter { detector.observe(elbowAngle: $0.element, at: Double($0.offset) * 0.1) }
        XCTAssertEqual(counts.count, 1)
        XCTAssertFalse(detector.observe(elbowAngle: 160, at: 1.1))
    }

    func testUncertainFrameDoesNotCount() {
        var detector = RepCycleDetector()
        for (index, angle) in [158.0, 160, 110, 108].enumerated() {
            XCTAssertFalse(detector.observe(elbowAngle: angle, at: Double(index) * 0.1))
        }
        XCTAssertFalse(detector.observe(elbowAngle: nil, at: 0.4))
        XCTAssertFalse(detector.observe(elbowAngle: 158, at: 0.5))
        XCTAssertFalse(detector.observe(elbowAngle: 160, at: 0.6))
        XCTAssertFalse(detector.observe(elbowAngle: 110, at: 0.7))
        XCTAssertFalse(detector.observe(elbowAngle: 108, at: 0.8))
        XCTAssertFalse(detector.observe(elbowAngle: 158, at: 0.9))
        XCTAssertTrue(detector.observe(elbowAngle: 160, at: 1.0))
    }

    func testProgressSumsSameDayAndExcludesPartialFromStreak() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let now = Date(timeIntervalSince1970: 1_700_000_000)
        let day = calendar.startOfDay(for: now)
        func record(_ reps: Int, _ outcome: SessionOutcome, _ dayOffset: Int) -> SessionRecord {
            let end = calendar.date(byAdding: .day, value: dayOffset, to: day)!.addingTimeInterval(3600)
            return SessionRecord(target: 15, acceptedReps: reps, cameraReps: reps, tapReps: 0,
                correctionDelta: 0, startedAt: end.addingTimeInterval(-60), endedAt: end,
                completionDay: SessionRecord.dayKey(for: end, calendar: calendar),
                elapsedSeconds: 60, outcome: outcome)
        }
        let data = [record(15, .completed, 0), record(7, .savedPartial, 0), record(8, .savedPartial, -1)]
        let snapshot = ProgressCalculator.snapshot(for: data, now: now, calendar: calendar)
        XCTAssertEqual(snapshot.lifetimeReps, 30)
        XCTAssertEqual(snapshot.activeDays, 2)
        XCTAssertEqual(snapshot.lastSevenDays.suffix(2).map(\.reps), [8, 22])
        XCTAssertEqual(snapshot.currentStreak, 1)
        XCTAssertEqual(snapshot.repsToMilestone, 470)
    }

    func testGraceDayAndSecondMissedDayReset() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let completed = Date(timeIntervalSince1970: 1_700_000_000)
        let record = SessionRecord(target: 15, acceptedReps: 15, cameraReps: 15,
            tapReps: 0, correctionDelta: 0, startedAt: completed.addingTimeInterval(-60),
            endedAt: completed, completionDay: SessionRecord.dayKey(for: completed, calendar: calendar),
            elapsedSeconds: 60, outcome: .completed)
        let oneMissedDay = calendar.date(byAdding: .day, value: 2, to: completed)!
        let twoMissedDays = calendar.date(byAdding: .day, value: 3, to: completed)!
        let grace = ProgressCalculator.snapshot(for: [record], now: oneMissedDay, calendar: calendar)
        XCTAssertEqual(grace.currentStreak, 1)
        XCTAssertTrue(grace.graceDayUsed)
        let reset = ProgressCalculator.snapshot(for: [record], now: twoMissedDays, calendar: calendar)
        XCTAssertEqual(reset.currentStreak, 0)
    }

    func testOneGraceDayWithinStreakCountsCompletedDaysOnly() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let today = calendar.startOfDay(for: Date(timeIntervalSince1970: 1_700_000_000))
        let records = [-4, -2, -1].map { offset -> SessionRecord in
            let end = calendar.date(byAdding: .day, value: offset, to: today)!.addingTimeInterval(3600)
            return SessionRecord(target: 10, acceptedReps: 10, cameraReps: 10,
                tapReps: 0, correctionDelta: 0, startedAt: end.addingTimeInterval(-60),
                endedAt: end, completionDay: SessionRecord.dayKey(for: end, calendar: calendar),
                elapsedSeconds: 60, outcome: .completed)
        }
        let snapshot = ProgressCalculator.snapshot(for: records, now: today, calendar: calendar)
        XCTAssertEqual(snapshot.currentStreak, 3)
        XCTAssertTrue(snapshot.graceDayUsed)
    }

    func testCompletionDayRemainsStableAcrossTimeZoneChange() {
        var east = Calendar(identifier: .gregorian)
        east.timeZone = TimeZone(secondsFromGMT: 10 * 3600)!
        var west = Calendar(identifier: .gregorian)
        west.timeZone = TimeZone(secondsFromGMT: -8 * 3600)!
        let end = Date(timeIntervalSince1970: 1_700_000_000)
        let dayKey = SessionRecord.dayKey(for: end, calendar: east)
        let record = SessionRecord(target: 10, acceptedReps: 10, cameraReps: 10,
            tapReps: 0, correctionDelta: 0, startedAt: end.addingTimeInterval(-60),
            endedAt: end, completionDay: dayKey, elapsedSeconds: 60, outcome: .completed)
        let snapshot = ProgressCalculator.snapshot(for: [record], now: end.addingTimeInterval(86_400), calendar: west)
        let credited = snapshot.lastSevenDays.first { $0.reps == 10 }
        XCTAssertEqual(credited.map { SessionRecord.dayKey(for: $0.date, calendar: west) }, dayKey)
    }
}
