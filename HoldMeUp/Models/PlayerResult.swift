import Foundation

struct PlayerResult: Identifiable, Codable, Equatable {
    var id: String
    var nickname: String
    var avatar: AvatarOption
    var flatDuration: TimeInterval
    var maxTiltDegrees: Double
    var eliminated: Bool
}
