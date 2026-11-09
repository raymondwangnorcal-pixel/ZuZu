import Foundation
import Combine

@MainActor
final class SessionStore: ObservableObject {
    @Published private(set) var records: [SessionRecord] = []
    @Published var storageError: String?

    private let fileURL: URL
    private var loadFailed = false

    init(fileURL: URL? = nil) {
        if let fileURL {
            self.fileURL = fileURL
        } else {
            let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            self.fileURL = support.appendingPathComponent("ZuZu", isDirectory: true)
                .appendingPathComponent("sessions.json")
        }
        load()
    }

    var progress: ProgressSnapshot { ProgressCalculator.snapshot(for: records) }

    func hasCompletedGoal(on date: Date) -> Bool {
        let dayKey = SessionRecord.dayKey(for: date)
        return records.contains {
            $0.outcome == .completed && $0.completionDay == dayKey
        }
    }

    @discardableResult
    func save(_ record: SessionRecord) -> Bool {
        guard !records.contains(where: { $0.id == record.id }) else { return true }
        var revised = records
        revised.append(record)
        return persist(revised)
    }

    @discardableResult
    func delete(_ id: UUID) -> Bool {
        persist(records.filter { $0.id != id })
    }

    private func load() {
        do {
            let data = try Data(contentsOf: fileURL)
            records = try JSONDecoder().decode([SessionRecord].self, from: data)
        } catch CocoaError.fileReadNoSuchFile {
            records = []
        } catch {
            loadFailed = true
            storageError = "Couldn’t load saved sessions: \(error.localizedDescription)"
        }
    }

    private func persist(_ revised: [SessionRecord]) -> Bool {
        guard !loadFailed else {
            storageError = "Saved sessions could not be read. ZuZu will not overwrite them."
            return false
        }
        do {
            try FileManager.default.createDirectory(
                at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true
            )
            let data = try JSONEncoder().encode(revised)
            try data.write(to: fileURL, options: .atomic)
            records = revised.sorted { $0.endedAt > $1.endedAt }
            storageError = nil
            return true
        } catch {
            storageError = "Couldn’t save sessions: \(error.localizedDescription)"
            return false
        }
    }
}
