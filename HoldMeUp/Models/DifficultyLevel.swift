import Foundation

/// Tolerance and duration values are placeholders from initial planning —
/// see CLAUDE.md "Deferred / TODO". Real values need playtesting on a
/// physical device before launch.
enum DifficultyLevel: String, CaseIterable, Codable, Identifiable, Equatable {
    case easy, medium, hard, savage

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        case .savage: return "Savage"
        }
    }

    /// Maximum allowed tilt, in degrees from flat, before elimination.
    var toleranceDegrees: Double {
        switch self {
        case .easy: return 50
        case .medium: return 30
        case .hard: return 18
        case .savage: return 8
        }
    }

    var durationSeconds: Int {
        switch self {
        case .easy: return 180
        case .medium: return 300
        case .hard: return 240
        case .savage: return 200
        }
    }
}
