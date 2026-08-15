import SwiftUI

@main
struct HoldMeUpApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .onAppear { appState.goHomeIfProfileExists() }
        }
    }
}
