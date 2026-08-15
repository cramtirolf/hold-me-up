import SwiftUI

struct StatusPill: View {
    let text: String
    var color: Color = Theme.accent
    var tint: Color = Theme.accentTint

    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 6, height: 6)
            Text(text).font(.system(size: 11, weight: .bold))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(tint)
        .clipShape(Capsule())
    }
}
