import Foundation

struct Player: Identifiable, Codable, Equatable {
    var id: String
    var nickname: String
    var avatar: AvatarOption
    var isHost: Bool
}
