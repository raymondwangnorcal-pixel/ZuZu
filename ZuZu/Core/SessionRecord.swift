import Foundation

public enum SessionOutcome: String, Codable, Sendable {
    case completed
    case savedPartial
}

public struct SessionRecord: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public let target: Int
    public let acceptedReps: Int
    public let cameraReps: Int
    public let tapReps: Int
    public let correctionDelta: Int
    public let startedAt: Date
    public let endedAt: Date
    /// Calendar date shown on the iPhone when the session was saved (yyyy-MM-dd).
    public let completionDay: String
    public let completionTimeZoneID: String
    public let elapsedSeconds: TimeInterval
    public let outcome: SessionOutcome

    public init(
        id: UUID = UUID(), target: Int, acceptedReps: Int,
        cameraReps: Int, tapReps: Int, correctionDelta: Int,
        startedAt: Date, endedAt: Date, completionDay: String? = nil,
        completionTimeZoneID: String = TimeZone.current.identifier,
        elapsedSeconds: TimeInterval,
        outcome: SessionOutcome
    ) {
        self.id = id
        self.target = target
        self.acceptedReps = acceptedReps
        self.cameraReps = cameraReps
        self.tapReps = tapReps
        self.correctionDelta = correctionDelta
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.completionDay = completionDay ?? Self.dayKey(for: endedAt)
        self.completionTimeZoneID = completionTimeZoneID
        self.elapsedSeconds = elapsedSeconds
        self.outcome = outcome
    }

    public static func dayKey(for date: Date, calendar: Calendar = .current) -> String {
        let parts = calendar.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", parts.year ?? 0, parts.month ?? 0, parts.day ?? 0)
    }
}
