import SwiftUI

enum AvatarOption: String, CaseIterable, Codable, Identifiable, Equatable {
    case parrot, elephant, dog, cat, lion

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .parrot: return "🦜"
        case .elephant: return "🐘"
        case .dog: return "🐶"
        case .cat: return "🐱"
        case .lion: return "🦁"
        }
    }

    var tint: Color { Theme.playerColor(for: self) }
}
