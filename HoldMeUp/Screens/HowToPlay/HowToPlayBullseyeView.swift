import SwiftUI

struct HowToPlayBullseyeView: View {
    @State private var angle: Double = 0

    var body: some View {
        VStack(spacing: 8) {
            Text("Watch the bullseye")
                .font(.system(size: 19, weight: .heavy, design: .rounded))
            Text("The green dot shows your tilt. Stay inside the rings and you're still in the game.")
                .font(.system(size: 13.5))
                .foregroundStyle(Theme.inkSoft)
                .multilineTextAlignment(.center)

            Spacer()

            BullseyeView(tiltDegrees: 12, tiltX: cos(angle) * 0.4, tiltY: sin(angle) * 0.4, toleranceDegrees: 50)
                .onAppear {
                    withAnimation(.linear(duration: 5.5).repeatForever(autoreverses: false)) {
                        angle = .pi * 2
                    }
                }

            Spacer()
        }
        .padding(24)
    }
}
