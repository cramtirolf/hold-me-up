import SwiftUI

struct PlayerRow: View {
    let player: Player
    var isYou: Bool = false

    var body: some View {
        HStack(spacing: 10) {
            AvatarBadge(avatar: player.avatar, size: 36)
            Text(player.nickname).font(.system(size: 13.5, weight: .bold))
            Spacer()
            if player.isHost {
                RowTag(text: "HOST", color: Theme.accent, tint: Theme.accentTint)
            } else if isYou {
                RowTag(text: "YOU", color: Theme.inkSoft, tint: Theme.surfaceBorder)
            } else {
                Image(systemName: "checkmark")
                    .foregroundStyle(Theme.accent)
                    .font(.system(size: 13, weight: .bold))
            }
        }
        .padding(9)
        .background(Theme.surface2)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct RowTag: View {
    let text: String
    let color: Color
    let tint: Color

    var body: some View {
        Text(text)
            .font(.system(size: 9.5, weight: .bold))
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(tint)
            .foregroundStyle(color)
            .clipShape(RoundedRectangle(cornerRadius: 7))
    }
}
