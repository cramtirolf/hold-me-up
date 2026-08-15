import SwiftUI

/// The core tilt visualization — a bullseye/spirit-level. The dot centers
/// when flat, drifts outward with real tilt, and turns red past tolerance.
struct BullseyeView: View {
    var tiltDegrees: Double
    var tiltX: Double = 0
    var tiltY: Double = 0
    var toleranceDegrees: Double
    var diameter: CGFloat = 172

    private var isWithinTolerance: Bool { tiltDegrees <= toleranceDegrees }
    private var dotColor: Color { isWithinTolerance ? Theme.accent : Theme.bad }
    private var dotTint: Color { isWithinTolerance ? Theme.accentTint : Theme.badTint }

    private var dotOffset: CGSize {
        let maxRadius = diameter * 0.36
        let x = max(-1, min(1, tiltX)) * maxRadius
        let y = max(-1, min(1, -tiltY)) * maxRadius
        return CGSize(width: x, height: y)
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(RadialGradient(colors: [dotTint.opacity(0.6), .clear], center: .center, startRadius: 0, endRadius: diameter * 0.42))

            Circle().stroke(Theme.surfaceBorder, lineWidth: 1.4)
            Circle().stroke(Theme.surfaceBorder, lineWidth: 1.4).padding(diameter * 0.15)
            Circle().stroke(Theme.surfaceBorder, lineWidth: 1.4).padding(diameter * 0.30)
            Rectangle().fill(Theme.surfaceBorder).frame(height: 1).padding(.horizontal, diameter * 0.05)
            Rectangle().fill(Theme.surfaceBorder).frame(width: 1).padding(.vertical, diameter * 0.05)

            Circle()
                .fill(dotColor)
                .frame(width: diameter * 0.17, height: diameter * 0.17)
                .shadow(color: dotTint, radius: 6)
                .offset(dotOffset)
                .animation(.easeOut(duration: 0.15), value: dotOffset.width)
        }
        .frame(width: diameter, height: diameter)
        .background(Circle().fill(Theme.surface))
        .overlay(Circle().stroke(Theme.surfaceBorder, lineWidth: 2))
    }
}
