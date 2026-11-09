import SwiftUI

@main
struct ZuZuApp: App {
    @StateObject private var store = SessionStore()
    @StateObject private var workout = WorkoutController()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .environmentObject(workout)
                .preferredColorScheme(.dark)
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase != .active { workout.pauseForInterruption() }
                }
        }
    }
}
