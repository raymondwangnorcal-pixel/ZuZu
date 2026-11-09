import SwiftUI

struct RootView: View {
    @EnvironmentObject private var workout: WorkoutController
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack { StartView() }
                .tabItem { Label("Start", systemImage: "figure.strengthtraining.traditional") }
                .tag(0)
            NavigationStack { ProgressView() }
                .tabItem { Label("Progress", systemImage: "chart.bar.fill") }
                .tag(1)
        }
        .tint(ZuZuTheme.amber)
        .fullScreenCover(isPresented: Binding(
            get: { workout.phase != .idle },
            set: { if !$0 { workout.discard() } }
        )) {
            WorkoutFlowView()
        }
    }
}

struct StartView: View {
    @EnvironmentObject private var workout: WorkoutController
    @State private var target = 15

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 7) {
                    Text("Pushup session")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(ZuZuTheme.primary)
                    Text("Set a goal, then let the camera count with you.")
                        .font(.subheadline)
                        .foregroundStyle(ZuZuTheme.muted)
                }
                .padding(.top, 24)

                VStack(alignment: .leading, spacing: 22) {
                    Label("TODAY'S GOAL", systemImage: "figure.strengthtraining.traditional")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(ZuZuTheme.amber)
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("\(target)")
                            .font(.system(size: 80, weight: .bold, design: .rounded))
                            .contentTransition(.numericText())
                        Text("pushups")
                            .font(.title3.weight(.medium))
                            .foregroundStyle(ZuZuTheme.muted)
                    }
                    HStack(spacing: 14) {
                        Button { if target > 5 { target -= 1 } } label: {
                            Image(systemName: "minus")
                                .frame(maxWidth: .infinity)
                        }
                        .disabled(target <= 5)
                        Button { if target < 100 { target += 1 } } label: {
                            Image(systemName: "plus")
                                .frame(maxWidth: .infinity)
                        }
                        .disabled(target >= 100)
                    }
                    .buttonStyle(TargetStepButtonStyle())
                    HStack(spacing: 9) {
                        ForEach([10, 15, 20, 30], id: \.self) { preset in
                            Button("\(preset)") { target = preset }
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(target == preset ? ZuZuTheme.background : ZuZuTheme.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    target == preset ? ZuZuTheme.amber : ZuZuTheme.raised,
                                    in: RoundedRectangle(cornerRadius: 13)
                                )
                        }
                    }
                    Text("Choose 5–100 reps. You can correct the count before saving.")
                        .font(.footnote)
                        .foregroundStyle(ZuZuTheme.muted)
                }
                .zuzuCard()

                VStack(alignment: .leading, spacing: 12) {
                    Label("Camera counting", systemImage: "camera.viewfinder")
                        .font(.headline)
                        .foregroundStyle(ZuZuTheme.primary)
                    Text("Frames stay on this iPhone. No video is recorded or uploaded.")
                        .font(.subheadline)
                        .foregroundStyle(ZuZuTheme.muted)
                }
                .zuzuCard()

                Button {
                    workout.prepare(target: target)
                } label: {
                    Text("Continue")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                }
                .buttonStyle(.plain)
                .foregroundStyle(Color.black)
                .background(ZuZuTheme.amber, in: RoundedRectangle(cornerRadius: 18))
                .accessibilityHint("Set up your pushup session")
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 28)
        }
        .background(ZuZuTheme.background)
        .toolbar(.hidden, for: .navigationBar)
    }
}

private struct TargetStepButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3.weight(.bold))
            .foregroundStyle(ZuZuTheme.primary)
            .padding(.vertical, 13)
            .background(ZuZuTheme.raised.opacity(configuration.isPressed ? 0.7 : 1),
                        in: RoundedRectangle(cornerRadius: 13))
    }
}

struct WorkoutFlowView: View {
    @EnvironmentObject private var workout: WorkoutController

    var body: some View {
        Group {
            switch workout.phase {
            case .idle:
                Color.clear
            case .setup:
                CameraSetupView()
            case .active, .paused, .goalReview:
                SessionView()
            case .completed:
                CompletionView()
            }
        }
        .background(ZuZuTheme.background)
        .preferredColorScheme(.dark)
    }
}
