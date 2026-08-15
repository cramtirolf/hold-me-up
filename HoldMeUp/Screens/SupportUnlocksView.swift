import SwiftUI

struct SupportUnlocksView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button { appState.route = .home } label: { Image(systemName: "chevron.left") }
                Text("Support & Unlocks").font(.system(size: 20, weight: .heavy, design: .rounded))
                Spacer()
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Unlock More Players").font(.system(size: 15, weight: .heavy, design: .rounded))
                HStack(spacing: 8) {
                    CompareTile(value: "\(GameConfig.freeTierMaxPlayers)", label: "Free")
                    CompareTile(value: "\(GameConfig.partyPackMaxPlayers)", label: "Unlocked")
                }
                Button("Unlock — Party Pack") {
                    // TODO: replace with a real StoreService.purchase(...) call
                    // once IAP products exist in App Store Connect — see CLAUDE.md.
                    appState.maxPlayersAllowed = GameConfig.partyPackMaxPlayers
                }
                .buttonStyle(PrimaryButtonStyle())
                Text("Only the host needs this. Joining is always free.")
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.inkFaint)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(14)
            .background(Theme.surface2)
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Theme.surfaceBorder, lineWidth: 1.5))
            .clipShape(RoundedRectangle(cornerRadius: 18))

            VStack(alignment: .leading, spacing: 10) {
                Text("Tip the Developer").font(.system(size: 15, weight: .heavy, design: .rounded))
                Text("Enjoying the game? A small tip helps me keep building fun stuff.")
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.inkSoft)
                HStack(spacing: 7) {
                    ForEach(["$0.99", "$2.99", "$4.99"], id: \.self) { amount in
                        Text(amount)
                            .font(.system(size: 12.5, weight: .heavy, design: .monospaced))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 9)
                            .background(Theme.surface)
                            .overlay(RoundedRectangle(cornerRadius: 11).stroke(Theme.surfaceBorder, lineWidth: 1.3))
                            .clipShape(RoundedRectangle(cornerRadius: 11))
                    }
                }
            }
            .padding(14)
            .background(Theme.surface2)
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Theme.surfaceBorder, lineWidth: 1.5))
            .clipShape(RoundedRectangle(cornerRadius: 18))

            Spacer()

            Button("Restore Purchases") {}
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Theme.inkSoft)
                .frame(maxWidth: .infinity)
        }
        .padding(24)
        .background(Theme.background.ignoresSafeArea())
    }
}

private struct CompareTile: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value).font(.system(size: 18, weight: .heavy, design: .monospaced))
            Text(label.uppercased()).font(.system(size: 9.5, weight: .semibold)).foregroundStyle(Theme.inkFaint)
        }
        .frame(maxWidth: .infinity)
        .padding(9)
        .background(Theme.surface)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.surfaceBorder, lineWidth: 1.3))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
