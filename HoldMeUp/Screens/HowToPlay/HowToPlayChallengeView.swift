import SwiftUI

struct HowToPlayChallengeView: View {
    var body: some View {
        ZStack {
            BullseyeView(tiltDegrees: 3, toleranceDegrees: 50)

            VStack(spacing: 8) {
                Text("Stay flat during the challenge")
                    .font(.system(size: 19, weight: .heavy, design: .rounded))
                    .multilineTextAlignment(.center)
                Text("Do the challenge together while keeping it as level as you can.")
                    .font(.system(size: 13.5))
                    .foregroundStyle(Theme.inkSoft)
                    .multilineTextAlignment(.center)
                Spacer()
            }

            VStack {
                Spacer()
                Text("02:14").font(.system(size: 22, weight: .heavy, design: .monospaced))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
    }
}
