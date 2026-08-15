import SwiftUI
import MultipeerConnectivity

struct JoinListView: View {
    @EnvironmentObject var appState: AppState

    private var hosts: [(MCPeerID, MultipeerService.DiscoveryInfo)] {
        (appState.multipeer?.nearbyHosts ?? [:]).map { ($0.key, $0.value) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button { appState.leaveGame() } label: { Image(systemName: "chevron.left") }
                Text("Find a Game").font(.system(size: 20, weight: .heavy, design: .rounded))
                Spacer()
            }

            StatusPill(text: "Looking nearby…").frame(maxWidth: .infinity)

            if hosts.isEmpty {
                Spacer()
                Text("No games found yet.\nMake sure a friend is hosting nearby.")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.inkFaint)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(hosts, id: \.0) { peerID, info in
                            Button { appState.joinGame(peerID: peerID) } label: {
                                HostCard(info: info)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .padding(24)
        .background(Theme.background.ignoresSafeArea())
    }
}

private struct HostCard: View {
    let info: MultipeerService.DiscoveryInfo

    var body: some View {
        HStack(spacing: 12) {
            AvatarBadge(avatar: info.hostAvatar, size: 36)
            VStack(alignment: .leading, spacing: 3) {
                Text("\(info.hostNickname)'s Game").font(.system(size: 14, weight: .bold, design: .rounded))
                HStack(spacing: 6) {
                    Text(info.difficulty.displayName.uppercased())
                        .font(.system(size: 9.5, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Theme.surfaceBorder, lineWidth: 1.3))
                    Text("\(info.playerCount)/\(info.maxPlayers) players")
                        .font(.system(size: 10.5, weight: .semibold))
                        .foregroundStyle(Theme.inkFaint)
                }
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Theme.inkFaint)
        }
        .padding(12)
        .background(Theme.surface2)
        .overlay(RoundedRectangle(cornerRadius: 17).stroke(Theme.surfaceBorder, lineWidth: 1.5))
        .clipShape(RoundedRectangle(cornerRadius: 17))
    }
}
