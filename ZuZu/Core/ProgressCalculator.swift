import Foundation

public struct DailyReps: Equatable, Sendable {
    public let date: Date
    public let reps: Int
}

public struct ProgressSnapshot: Equatable, Sendable {
    public let lifetimeReps: Int
    public let activeDays: Int
    public let lastSevenDays: [DailyReps]
    public let currentStreak: Int
    public let graceDayUsed: Bool
    public let nextMilestone: Int
    public let repsToMilestone: Int
}

public enum ProgressCalculator {
    public static func snapshot(
        for records: [SessionRecord], now: Date = Date(), calendar: Calendar = .current
    ) -> ProgressSnapshot {
        let today = calendar.startOfDay(for: now)
        var byDay: [Date: Int] = [:]
        var completedDays: Set<Date> = []
        for record in records {
            let day = date(for: record.completionDay, calendar: calendar)
                ?? calendar.startOfDay(for: record.endedAt)
            byDay[day, default: 0] += record.acceptedReps
            if record.outcome == .completed { completedDays.insert(day) }
        }
        let total = records.reduce(0) { $0 + $1.acceptedReps }
        let days = (0..<7).reversed().compactMap { offset -> DailyReps? in
            guard let date = calendar.date(byAdding: .day, value: -offset, to: today) else { return nil }
            return DailyReps(date: date, reps: byDay[date, default: 0])
        }
        let (streak, graceUsed) = streakState(completedDays: completedDays, today: today, calendar: calendar)
        let next = ((total / 500) + 1) * 500
        return ProgressSnapshot(
            lifetimeReps: total,
            activeDays: byDay.values.filter { $0 > 0 }.count,
            lastSevenDays: days,
            currentStreak: streak,
            graceDayUsed: graceUsed,
            nextMilestone: next,
            repsToMilestone: next - total
        )
    }

    private static func date(for key: String, calendar: Calendar) -> Date? {
        let parts = key.split(separator: "-").compactMap { Int($0) }
        guard parts.count == 3 else { return nil }
        return calendar.date(from: DateComponents(year: parts[0], month: parts[1], day: parts[2]))
    }

    private static func streakState(
        completedDays: Set<Date>, today: Date, calendar: Calendar
    ) -> (Int, Bool) {
        guard let latest = completedDays.max() else { return (0, false) }
        let daysSinceLatest = calendar.dateComponents([.day], from: latest, to: today).day ?? Int.max
        // Today is still in progress. Only fully elapsed missed days consume grace.
        guard daysSinceLatest <= 2 else { return (0, false) }
        var count = 0
        var missedInARow = 0
        var usedGrace = daysSinceLatest == 2
        var cursor = latest
        let earliest = completedDays.min() ?? latest
        while cursor >= earliest {
            if completedDays.contains(cursor) {
                count += 1
                missedInARow = 0
            } else {
                missedInARow += 1
                if missedInARow == 2 { break }
                usedGrace = true
            }
            guard let previous = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = previous
        }
        return (count, usedGrace)
    }
}
