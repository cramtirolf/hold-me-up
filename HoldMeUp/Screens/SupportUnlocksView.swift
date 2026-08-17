import SwiftUI

enum PartyPackTierState: Equatable {
    case locked
    case unlocked
}

func partyPackTierState(maxPlayersAllowed: Int) -> PartyPackTierState {
    maxPlayersAllowed >= GameConfig.partyPackMaxPlayers ? .unlocked : .locked
}

struct SupportUnlocksView: View {
    @EnvironmentObject var appState: AppState
    @State private var showPartyPackPopup = false
    @State private var showDonationPopup = false

    var body: some View {
        ZStack {
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
                        partyPackTile
                    }
                    Button("Unlock — Party Pack") {
                        showPartyPackPopup = true
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(isPartyPackUnlocked)
                    .opacity(isPartyPackUnlocked ? 0.5 : 1)
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
                            Button {
                                showDonationPopup = true
                            } label: {
                                Text(amount)
                                    .font(.system(size: 12.5, weight: .heavy, design: .monospaced))
                                    .foregroundStyle(Theme.ink)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 9)
                                    .background(Theme.surface)
                                    .overlay(RoundedRectangle(cornerRadius: 11).stroke(Theme.surfaceBorder, lineWidth: 1.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 11))
                            }
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

            if showPartyPackPopup {
                ConfirmationPopupView(title: "WELCOME TO PARTY MODE\nup to 8 players!") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                        ForEach(0..<GameConfig.partyPackMaxPlayers, id: \.self) { _ in
                            Image(systemName: "person.fill")
                                .font(.system(size: 22))
                                .foregroundStyle(Theme.accent)
                        }
                    }
                } onContinue: {
                    // TODO: replace with a real StoreService.purchase(...) call
                    // once IAP products exist in App Store Connect — see CLAUDE.md.
                    appState.maxPlayersAllowed = GameConfig.partyPackMaxPlayers
                    showPartyPackPopup = false
                }
            }

            if showDonationPopup {
                ConfirmationPopupView(title: "MANY THANKS!\nEnjoy the game") {
                    Text("😍").font(.system(size: 48))
                } onContinue: {
                    showDonationPopup = false
                }
            }
        }
    }

    private var isPartyPackUnlocked: Bool {
        partyPackTierState(maxPlayersAllowed: appState.maxPlayersAllowed) == .unlocked
    }

    private var partyPackTile: some View {
        switch partyPackTierState(maxPlayersAllowed: appState.maxPlayersAllowed) {
        case .locked:
            return CompareTile(value: "\(GameConfig.partyPackMaxPlayers)", label: "Locked", labelColor: Theme.bad.opacity(0.6))
        case .unlocked:
            return CompareTile(value: "\(GameConfig.partyPackMaxPlayers)", label: "Unlocked")
        }
    }
}

private struct CompareTile: View {
    let value: String
    let label: String
    var labelColor: Color = Theme.inkFaint

    var body: some View {
        VStack(spacing: 2) {
            Text(value).font(.system(size: 18, weight: .heavy, design: .monospaced))
            Text(label.uppercased()).font(.system(size: 9.5, weight: .semibold)).foregroundStyle(labelColor)
        }
        .frame(maxWidth: .infinity)
        .padding(9)
        .background(Theme.surface)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.surfaceBorder, lineWidth: 1.3))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
