import SwiftUI

struct CompletionView: View {
    @EnvironmentObject private var workout: WorkoutController
    @EnvironmentObject private var store: SessionStore

    private var complete: Bool { workout.savedRecord?.outcome == .completed }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Image("CompletionHero")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 340)
            .accessibilityLabel("Snoozy celebrates your pushups")
            .padding(.bottom, 26)

            Text(complete ? "Goal complete!" : "Session saved")
                .font(.system(size: 32, weight: .bold))
            Text("\(workout.count) pushups · \(complete ? "Goal reached" : "Partial session")")
                .font(.subheadline)
                .foregroundStyle(ZuZuTheme.muted)
                .padding(.top, 5)

            if complete && workout.earnedNewStreakDay {
                HStack(spacing: 12) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(ZuZuTheme.amber)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("\(store.progress.currentStreak)-day streak")
                            .font(.headline)
                        Text("A goal completed today. Keep it going!")
                            .font(.caption)
                            .foregroundStyle(ZuZuTheme.muted)
                    }
                    Spacer()
                    Text("+1")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(ZuZuTheme.mint)
                }
                .zuzuCard(radius: 18)
                .padding(.top, 24)
            }
            Spacer()
            Button {
                workout.finish()
            } label: {
                Text("Done")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.black)
            .background(ZuZuTheme.amber, in: RoundedRectangle(cornerRadius: 17))
        }
        .padding(.horizontal, 22)
        .padding(.bottom, 22)
        .frame(maxWidth: .infinity)
        .background(ZuZuTheme.background)
    }
}
