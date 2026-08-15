import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            switch appState.route {
            case .onboarding:
                OnboardingView()
            case .home:
                HomeView()
            case .howToPlay:
                HowToPlayFlowView()
            case .hostLobby:
                HostLobbyView()
            case .joinList:
                JoinListView()
            case .sharedLobby:
                SharedLobbyView()
            case .gameplay(let difficulty):
                GameplayView(difficulty: difficulty)
            case .results:
                ResultsView()
            case .support:
                SupportUnlocksView()
            }
        }
        .animation(.easeInOut(duration: 0.25), value: appState.route)
    }
}
