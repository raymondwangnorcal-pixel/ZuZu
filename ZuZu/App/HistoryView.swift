import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var store: SessionStore
    @State private var pendingDelete: SessionRecord?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Saved sessions")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.top, 12)
                if store.records.isEmpty {
                    VStack(spacing: 13) {
                        Image(systemName: "figure.strengthtraining.traditional")
                            .font(.system(size: 42))
                            .foregroundStyle(ZuZuTheme.amber)
                        Text("No sessions yet")
                            .font(.headline)
                        Text("Completed goals and saved partial sessions will appear here.")
                            .font(.subheadline)
                            .foregroundStyle(ZuZuTheme.muted)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 50)
                    .zuzuCard()
                } else {
                    ForEach(store.records) { record in
                        HStack(spacing: 14) {
                            Image(systemName: record.outcome == .completed ? "checkmark.circle.fill" : "circle.lefthalf.filled")
                                .foregroundStyle(record.outcome == .completed ? ZuZuTheme.mint : ZuZuTheme.amber)
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 5) {
                                Text("\(record.acceptedReps) / \(record.target) pushups")
                                    .font(.headline)
                                Text(completionLabel(for: record))
                                    .font(.subheadline)
                                    .foregroundStyle(ZuZuTheme.muted)
                            }
                            Spacer(minLength: 4)
                            Menu {
                                Button("Delete session", systemImage: "trash", role: .destructive) {
                                    pendingDelete = record
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .font(.title3.weight(.semibold))
                                    .frame(width: 44, height: 44)
                                    .contentShape(Rectangle())
                            }
                            .accessibilityLabel("Options for \(record.acceptedReps) pushups on \(completionLabel(for: record))")
                        }
                        .zuzuCard(radius: 18)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(ZuZuTheme.background)
        .navigationTitle("Saved sessions")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .alert(pendingDelete.map { "Delete \($0.acceptedReps)-pushup session?" } ?? "Delete saved session?", isPresented: Binding(
            get: { pendingDelete != nil },
            set: { if !$0 { pendingDelete = nil } }
        )) {
            Button("Delete", role: .destructive) {
                if let pendingDelete { _ = store.delete(pendingDelete.id) }
                pendingDelete = nil
            }
            Button("Cancel", role: .cancel) { pendingDelete = nil }
        } message: {
            Text("Its reps will be removed from Progress and its goal may change your streak. This cannot be undone.")
        }
        .alert("Storage error", isPresented: Binding(
            get: { store.storageError != nil },
            set: { if !$0 { store.storageError = nil } }
        )) { Button("OK") { store.storageError = nil } } message: {
            Text(store.storageError ?? "Please try again.")
        }
    }

    private func completionLabel(for record: SessionRecord) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(identifier: record.completionTimeZoneID) ?? .current
        return formatter.string(from: record.endedAt)
    }
}
