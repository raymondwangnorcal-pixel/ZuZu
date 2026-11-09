import SwiftUI

struct ProgressView: View {
    @EnvironmentObject private var store: SessionStore

    private var snapshot: ProgressSnapshot { store.progress }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                Text("Progress")
                    .font(.system(size: 34, weight: .bold))
                    .padding(.top, 18)

                if let error = store.storageError {
                    Label(error, systemImage: "exclamationmark.triangle.fill")
                        .font(.subheadline)
                        .foregroundStyle(ZuZuTheme.amber)
                        .zuzuCard()
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("LIFETIME PUSHUPS")
                        .font(.caption.weight(.bold))
                        .tracking(1.2)
                        .foregroundStyle(ZuZuTheme.muted)
                    Text("\(snapshot.lifetimeReps)")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .foregroundStyle(ZuZuTheme.amber)
                    Text("\(snapshot.activeDays) active \(snapshot.activeDays == 1 ? "day" : "days")")
                        .font(.subheadline)
                        .foregroundStyle(ZuZuTheme.muted)
                }
                .zuzuCard()

                if store.records.isEmpty {
                    Text("Your first pushup session will start your progress here.")
                        .font(.subheadline)
                        .foregroundStyle(ZuZuTheme.muted)
                        .zuzuCard()
                }

                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("This week").font(.headline)
                        Spacer()
                        Text("Last 7 days")
                            .font(.caption)
                            .foregroundStyle(ZuZuTheme.muted)
                    }
                    HStack(alignment: .bottom, spacing: 10) {
                        ForEach(snapshot.lastSevenDays, id: \.date) { day in
                            VStack(spacing: 8) {
                                Text("\(day.reps)")
                                    .font(.caption2.weight(.semibold))
                                    .foregroundStyle(day.reps > 0 ? ZuZuTheme.primary : ZuZuTheme.muted)
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(day.reps > 0 ? ZuZuTheme.amber : ZuZuTheme.raised)
                                    .frame(height: max(8, CGFloat(day.reps) / CGFloat(max(1, snapshot.lastSevenDays.map(\.reps).max() ?? 1)) * 100))
                                Text(day.date, format: .dateTime.weekday(.narrow))
                                    .font(.caption2)
                                    .foregroundStyle(ZuZuTheme.muted)
                            }
                            .frame(maxWidth: .infinity)
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel("\(day.date.formatted(date: .abbreviated, time: .omitted)), \(day.reps) reps")
                        }
                    }
                    .frame(height: 145, alignment: .bottom)
                }
                .zuzuCard()

                HStack(spacing: 12) {
                    Image(systemName: "flame.fill")
                        .font(.title2)
                        .foregroundStyle(ZuZuTheme.amber)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("\(snapshot.currentStreak)-day streak")
                            .font(.headline)
                        Text(snapshot.graceDayUsed ? "Grace day used" : "Complete a goal to grow your streak")
                            .font(.caption)
                            .foregroundStyle(ZuZuTheme.muted)
                    }
                    Spacer()
                }
                .zuzuCard()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Next milestone: \(snapshot.nextMilestone)")
                        .font(.headline)
                    SwiftUI.ProgressView(value: Double(snapshot.lifetimeReps % 500), total: 500)
                        .tint(ZuZuTheme.amber)
                    Text("\(snapshot.repsToMilestone) reps to go")
                        .font(.subheadline)
                        .foregroundStyle(ZuZuTheme.muted)
                }
                .zuzuCard()

                NavigationLink {
                    HistoryView()
                } label: {
                    HStack {
                        Label("Saved sessions", systemImage: "clock.arrow.circlepath")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .font(.headline)
                    .foregroundStyle(ZuZuTheme.primary)
                }
                .zuzuCard()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 28)
        }
        .background(ZuZuTheme.background)
        .toolbar(.hidden, for: .navigationBar)
    }
}
