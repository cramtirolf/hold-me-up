import SwiftUI

struct AvatarBadge: View {
    let avatar: AvatarOption
    var size: CGFloat = 52
    var selected: Bool = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .fill(avatar.tint)
                .frame(width: size, height: size)
                .overlay(Text(avatar.emoji).font(.system(size: size * 0.46)))
                .overlay(Circle().stroke(Theme.ink, lineWidth: selected ? 2.5 : 0))

            if selected {
                Circle()
                    .fill(Theme.accent)
                    .frame(width: size * 0.34, height: size * 0.34)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: size * 0.18, weight: .bold))
                            .foregroundStyle(.white)
                    )
                    .overlay(Circle().stroke(Theme.surface, lineWidth: 2))
            }
        }
    }
}
