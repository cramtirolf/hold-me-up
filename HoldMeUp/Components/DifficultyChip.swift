import SwiftUI

struct DifficultyChip: View {
    let level: DifficultyLevel
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(level.displayName)
                .font(.system(size: 12, weight: .bold))
                .padding(.horizontal, 13)
                .padding(.vertical, 7)
                .background(selected ? Theme.accent : .clear)
                .foregroundStyle(selected ? .white : Theme.inkSoft)
                .overlay(Capsule().stroke(Theme.surfaceBorder, lineWidth: selected ? 0 : 1.5))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
