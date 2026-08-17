import SwiftUI

struct ConfirmationPopupView<Icon: View>: View {
    let title: String
    let icon: Icon
    let onContinue: () -> Void

    init(title: String, @ViewBuilder icon: () -> Icon, onContinue: @escaping () -> Void) {
        self.title = title
        self.icon = icon()
        self.onContinue = onContinue
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                icon

                Text(title)
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundStyle(Theme.ink)
                    .multilineTextAlignment(.center)

                Button("Continue", action: onContinue)
                    .buttonStyle(PrimaryButtonStyle())
            }
            .padding(24)
            .background(Theme.surface2)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Theme.surfaceBorder, lineWidth: 1.5))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 32)
        }
    }
}
