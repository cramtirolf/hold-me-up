import CoreMotion

/// Reads the device's tilt away from flat using CoreMotion's gravity vector.
/// No Info.plist entry is required for this — `NSMotionUsageDescription`
/// only applies to CMMotionActivityManager/CMPedometer, not raw device motion.
final class MotionService: ObservableObject {
    /// Angle, in degrees, between the device's face and flat (0° = perfectly flat).
    @Published private(set) var tiltDegrees: Double = 0
    /// Roughly -1...1, used only for positioning the dot in BullseyeView.
    @Published private(set) var tiltX: Double = 0
    @Published private(set) var tiltY: Double = 0

    private let motionManager = CMMotionManager()
    private let updateInterval = 1.0 / 20.0

    func start() {
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = updateInterval
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let self, let motion else { return }
            let gravity = motion.gravity
            self.tiltX = gravity.x
            self.tiltY = gravity.y
            let flatness = max(-1, min(1, abs(gravity.z)))
            self.tiltDegrees = acos(flatness) * 180 / .pi
        }
    }

    func stop() {
        motionManager.stopDeviceMotionUpdates()
    }
}
