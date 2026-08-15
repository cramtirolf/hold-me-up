import SwiftUI

struct ResultsView: View {
    @EnvironmentObject var appState: AppState

    private var results: [PlayerResult] { appState.gameSession?.finalResults ?? [] }
    private var winner: PlayerResult? { results.first }

    var body: some View {
        VStack(spacing: 16) {
            if let winner {
                VStack(spacing: 8) {
                    AvatarBadge(avatar: winner.avatar, size: 64)
                    Text("🏆 \(winner.nickname) Wins!").font(.system(size: 20, weight: .heavy, design: .rounded))
                    Text("Held it flat for \(timeString(winner.flatDuration))")
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.inkSoft)
                }
            }

            VStack(spacing: 6) {
                ForEach(Array(results.enumerated()), id: \.element.id) { index, result in
                    ResultRow(rank: index + 1, result: result)
                }
            }

            Spacer()

            VStack(spacing: 8) {
                Button("Play Again") {
                    if let multipeer = appState.multipeer, multipeer.isHost {
                        appState.route = .hostLobby
                    } else {
                        appState.route = .joinList
                    }
                }
                .buttonStyle(PrimaryButtonStyle())

                Button("Home") { appState.leaveGame() }
                    .buttonStyle(SecondaryButtonStyle())
            }
        }
        .padding(24)
        .background(Theme.background.ignoresSafeArea())
    }

    private func timeString(_ interval: TimeInterval) -> String {
        let total = max(0, Int(interval))
        return String(format: "%02d:%02d", total / 60, total % 60)
    }
}
