import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var nickname = ""
    @State private var selectedAvatar: AvatarOption = .parrot

    private var canContinue: Bool {
        !nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("What should\nwe call you?")
                .multilineTextAlignment(.center)
                .font(.system(size: 28, weight: .heavy, design: .rounded))

            VStack(alignment: .leading, spacing: 6) {
                Text("NICKNAME").font(.system(size: 11, weight: .bold)).foregroundStyle(Theme.inkFaint)
                TextField("Enter your nickname", text: $nickname)
                    .font(.system(size: 17, weight: .semibold))
                    .padding(12)
                    .background(Theme.surface2)
                    .clipShape(RoundedRectangle(cornerRadius: 13))
            }

            VStack(spacing: 10) {
                Text("CHOOSE YOUR AVATAR").font(.system(size: 11, weight: .bold)).foregroundStyle(Theme.inkFaint)
                HStack(spacing: 10) {
                    ForEach(AvatarOption.allCases) { avatar in
                        Button {
                            selectedAvatar = avatar
                        } label: {
                            AvatarBadge(avatar: avatar, selected: avatar == selectedAvatar)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            Spacer()

            Button("Let's play →") {
                appState.profileStore.save(nickname: nickname, avatar: selectedAvatar)
                appState.route = .home
            }
            .buttonStyle(PrimaryButtonStyle(isEnabled: canContinue))
            .disabled(!canContinue)
        }
        .padding(24)
        .background(Theme.background.ignoresSafeArea())
    }
}
