import SwiftUI

/// Same visual as ResultsView, reused as-is with sample data — this is a
/// static tutorial preview, not driven by a live GameSessionController.
struct HowToPlayWinningView: View {
    private let sample: [PlayerResult] = [
        PlayerResult(id: "priya", nickname: "Priya", avatar: .parrot, flatDuration: 167, maxTiltDegrees: 8, eliminated: false),
        PlayerResult(id: "alex", nickname: "Alex", avatar: .lion, flatDuration: 130, maxTiltDegrees: 12, eliminated: true),
        PlayerResult(id: "mark", nickname: "Mark", avatar: .elephant, flatDuration: 118, maxTiltDegrees: 15, eliminated: true),
        PlayerResult(id: "sam", nickname: "Sam", avatar: .dog, flatDuration: 41, maxTiltDegrees: 29, eliminated: true),
    ]

    var body: some View {
        VStack(spacing: 16) {
            if let winner = sample.first {
                VStack(spacing: 8) {
                    AvatarBadge(avatar: winner.avatar, size: 64)
                    Text("🏆 \(winner.nickname) Wins!").font(.system(size: 20, weight: .heavy, design: .rounded))
                    Text("Held it flat for \(timeString(winner.flatDuration))")
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.inkSoft)
                }
            }

            VStack(spacing: 6) {
                ForEach(Array(sample.enumerated()), id: \.element.id) { index, result in
                    ResultRow(rank: index + 1, result: result)
                }
            }

            Spacer()
        }
        .padding(24)
    }

    private func timeString(_ interval: TimeInterval) -> String {
        let total = max(0, Int(interval))
        return String(format: "%02d:%02d", total / 60, total % 60)
    }
}
