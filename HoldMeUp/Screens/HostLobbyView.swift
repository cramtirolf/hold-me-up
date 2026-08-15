import SwiftUI

struct HostLobbyView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedDifficulty: DifficultyLevel = .easy

    private var players: [Player] { appState.multipeer?.players ?? [] }
    private var hostNickname: String { appState.profileStore.profile?.nickname ?? "Your" }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button { appState.leaveGame() } label: { Image(systemName: "chevron.left") }
                Text("\(hostNickname)'s Game").font(.system(size: 20, weight: .heavy, design: .rounded))
                Spacer()
            }

            StatusPill(text: "Broadcasting nearby").frame(maxWidth: .infinity)

            HStack(spacing: 7) {
                ForEach(DifficultyLevel.allCases) { level in
                    DifficultyChip(level: level, selected: level == selectedDifficulty) {
                        selectedDifficulty = level
                    }
                }
            }

            Text("\(selectedDifficulty.durationSeconds / 60) min · stay within \(Int(selectedDifficulty.toleranceDegrees))° tilt")
                .font(.system(size: 12))
                .foregroundStyle(Theme.inkSoft)
                .frame(maxWidth: .infinity)

            Text("PLAYERS (\(players.count)/\(appState.maxPlayersAllowed))")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(Theme.inkFaint)

            VStack(spacing: 6) {
                ForEach(players) { player in
                    PlayerRow(player: player)
                }
                if appState.maxPlayersAllowed < GameConfig.maxPlayersHardCap {
                    Button {
                        appState.route = .support
                    } label: {
                        Text("🔒 Host \(GameConfig.maxPlayersHardCap - appState.maxPlayersAllowed) more players with Party Pack")
                            .font(.system(size: 11.5, weight: .semibold))
                            .foregroundStyle(Theme.inkFaint)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                            .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Theme.surfaceBorder, style: StrokeStyle(lineWidth: 1.5, dash: [4])))
                    }
                    .buttonStyle(.plain)
                }
            }

            Spacer()

            Button("Start Game") {
                appState.startGameAsHost(difficulty: selectedDifficulty)
            }
            .buttonStyle(PrimaryButtonStyle(isEnabled: players.count >= 2))
            .disabled(players.count < 2)
        }
        .padding(24)
        .background(Theme.background.ignoresSafeArea())
        .onAppear {
            if appState.multipeer == nil {
                appState.startHosting(difficulty: selectedDifficulty)
            }
        }
    }
}
