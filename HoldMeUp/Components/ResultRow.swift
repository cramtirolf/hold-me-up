import SwiftUI

struct ResultRow: View {
    let rank: Int
    let result: PlayerResult

    var body: some View {
        HStack(spacing: 10) {
            Text("\(rank)")
                .font(.system(size: 12, weight: .heavy, design: .monospaced))
                .foregroundStyle(Theme.inkFaint)
                .frame(width: 16)
            AvatarBadge(avatar: result.avatar, size: 36)
            Text(result.nickname).font(.system(size: 12.5, weight: .bold))
            Spacer()
            HStack(spacing: 9) {
                Text(timeString(result.flatDuration))
                Text("\(Int(result.maxTiltDegrees))°")
            }
            .font(.system(size: 11, weight: .bold, design: .monospaced))
            .foregroundStyle(Theme.inkSoft)
        }
        .padding(8)
        .background(Theme.surface2)
        .clipShape(RoundedRectangle(cornerRadius: 13))
    }

    private func timeString(_ interval: TimeInterval) -> String {
        let total = max(0, Int(interval))
        return String(format: "%02d:%02d", total / 60, total % 60)
    }
}
