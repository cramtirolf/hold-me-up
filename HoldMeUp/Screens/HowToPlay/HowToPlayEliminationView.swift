import SwiftUI
import AudioToolbox

struct HowToPlayEliminationView: View {
    @State private var escaped = false

    var body: some View {
        VStack(spacing: 8) {
            Text("Tilt too far, you're out")
                .font(.system(size: 19, weight: .heavy, design: .rounded))
            Text("Reach the edge of the bullseye and you're eliminated for this round.")
                .font(.system(size: 13.5))
                .foregroundStyle(Theme.inkSoft)
                .multilineTextAlignment(.center)

            Spacer()

            BullseyeView(
                tiltDegrees: escaped ? 60 : 3,
                tiltX: escaped ? 0.9 : 0,
                tiltY: escaped ? -0.6 : 0,
                toleranceDegrees: 50
            )
            Text("Out of bounds!").font(.system(size: 12.5, weight: .bold)).foregroundStyle(Theme.bad)
            StatusPill(text: "Waiting for a winner…", color: Theme.bad, tint: Theme.badTint)

            Spacer()
        }
        .padding(24)
        .onAppear {
            withAnimation(.easeIn(duration: 2.1)) { escaped = true }
            // TODO: swap this system sound for a real custom buzzer asset — see CLAUDE.md.
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
                AudioServicesPlaySystemSound(1053)
            }
        }
    }
}
