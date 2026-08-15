import SwiftUI

struct GameplayView: View {
    let difficulty: DifficultyLevel
    @EnvironmentObject var appState: AppState

    private var session: GameSessionController? { appState.gameSession }

    var body: some View {
        VStack(spacing: 8) {
            if let session {
                Text(timeString(session.timeRemaining))
                    .font(.system(size: 34, weight: .heavy, design: .monospaced))
                Text("\(difficulty.displayName) · tolerance \(Int(difficulty.toleranceDegrees))°")
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.inkSoft)

                Spacer()

                BullseyeView(tiltDegrees: session.myTiltDegrees, tiltX: session.myTiltX, tiltY: session.myTiltY, toleranceDegrees: difficulty.toleranceDegrees)

                Text("\(Int(session.myTiltDegrees))°")
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .foregroundStyle(session.amIEliminated ? Theme.bad : Theme.accent)

                Text(session.amIEliminated ? "Out of bounds!" : "Flat! Keep it steady")
                    .font(.system(size: 12.5, weight: .bold))
                    .foregroundStyle(session.amIEliminated ? Theme.bad : Theme.accent)

                Spacer()

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(session.standings.sorted(by: { $0.flatDuration > $1.flatDuration })) { result in
                            VStack(spacing: 4) {
                                AvatarBadge(avatar: result.avatar, size: 36)
                                    .opacity(result.eliminated ? 0.4 : 1)
                                Text(result.eliminated ? "✕ out" : timeString(result.flatDuration))
                                    .font(.system(size: 10.5, weight: .bold, design: .monospaced))
                            }
                        }
                    }
                }
            }
        }
        .padding(24)
        .background(Theme.background.ignoresSafeArea())
        .onChange(of: session?.finalResults) { _, results in
            if results != nil { appState.route = .results }
        }
    }

    private func timeString(_ interval: TimeInterval) -> String {
        let total = max(0, Int(interval))
        return String(format: "%02d:%02d", total / 60, total % 60)
    }
}
