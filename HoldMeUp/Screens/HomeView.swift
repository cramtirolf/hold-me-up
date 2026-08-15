import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState

    private var profile: PlayerProfile? { appState.profileStore.profile }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                if let profile {
                    HStack(spacing: 8) {
                        AvatarBadge(avatar: profile.avatar, size: 32)
                        Text(profile.nickname).font(.system(size: 14, weight: .bold))
                    }
                }
                Spacer()
                Button { appState.route = .support } label: {
                    Image(systemName: "gearshape.fill").foregroundStyle(Theme.inkFaint)
                }
            }

            Text("Hey \(profile?.nickname ?? "there") \(profile?.avatar.emoji ?? "")")
                .font(.system(size: 30, weight: .heavy, design: .rounded))

            VStack(spacing: 10) {
                ActionCard(
                    icon: "crown.fill", iconColor: Theme.accent, iconBackground: Theme.accentTint,
                    title: "Host a Game", subtitle: "Start a lobby, invite nearby players"
                ) {
                    appState.route = .hostLobby
                }
                ActionCard(
                    icon: "dot.radiowaves.left.and.right", iconColor: .white, iconBackground: Theme.playerColor(for: .elephant),
                    title: "Join a Game", subtitle: "Find games happening near you"
                ) {
                    appState.startBrowsing()
                }
                ActionCard(
                    icon: "book.fill", iconColor: .white, iconBackground: Theme.playerColor(for: .dog),
                    title: "How to Play", subtitle: "See the game in 4 quick screens"
                ) {
                    appState.route = .howToPlay
                }
            }

            Spacer()

            Button("♥ Support the developer") {
                appState.route = .support
            }
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(Theme.inkSoft)
            .frame(maxWidth: .infinity)
        }
        .padding(24)
        .background(Theme.background.ignoresSafeArea())
    }
}

private struct ActionCard: View {
    let icon: String
    let iconColor: Color
    let iconBackground: Color
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                RoundedRectangle(cornerRadius: 13)
                    .fill(iconBackground)
                    .frame(width: 44, height: 44)
                    .overlay(Image(systemName: icon).foregroundStyle(iconColor))
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.system(size: 15, weight: .bold, design: .rounded)).foregroundStyle(Theme.ink)
                    Text(subtitle).font(.system(size: 12)).foregroundStyle(Theme.inkSoft)
                }
                Spacer()
            }
            .padding(16)
            .background(Theme.surface2)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Theme.surfaceBorder, lineWidth: 1.5))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(.plain)
    }
}
