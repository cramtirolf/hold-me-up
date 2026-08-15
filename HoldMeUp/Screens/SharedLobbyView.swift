import SwiftUI

/// The lobby as seen by a joiner — same roster as HostLobbyView, but no
/// Start button. Transitions to gameplay automatically when the host's
/// `.startGame` message arrives.
struct SharedLobbyView: View {
    @EnvironmentObject var appState: AppState

    private var players: [Player] { appState.multipeer?.players ?? [] }
    private var hostName: String { players.first(where: { $0.isHost })?.nickname ?? "Host" }
    private var myID: String { appState.multipeer?.myID ?? "" }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button { appState.leaveGame() } label: { Image(systemName: "chevron.left") }
                Text("\(hostName)'s Game").font(.system(size: 20, weight: .heavy, design: .rounded))
                Spacer()
            }

            StatusPill(text: "Waiting for \(hostName) to start…").frame(maxWidth: .infinity)

            VStack(spacing: 6) {
                ForEach(players) { player in
                    PlayerRow(player: player, isYou: player.id == myID)
                }
            }

            Spacer()

            Text("💡 Hold your phone flat once the game starts.")
                .font(.system(size: 12.5))
                .foregroundStyle(Theme.inkSoft)
                .frame(maxWidth: .infinity)
                .padding(14)
                .background(Theme.surface2)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(24)
        .background(Theme.background.ignoresSafeArea())
        .onChange(of: appState.multipeer?.lastMessage) { _, message in
            if case .startGame(let difficulty) = message {
                appState.beginGameplay(difficulty: difficulty)
            }
        }
    }
}
