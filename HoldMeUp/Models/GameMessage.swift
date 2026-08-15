import Foundation

/// The wire protocol sent over MultipeerConnectivity. Star topology: joiners
/// only ever talk to the host, so `broadcast()` on any device correctly
/// reaches "the host" (from a joiner) or "everyone" (from the host).
enum GameMessage: Codable, Equatable {
    case roster(players: [Player])
    case startGame(difficulty: DifficultyLevel)
    case tiltUpdate(result: PlayerResult)
    case standings(entries: [PlayerResult])
    case gameOver(results: [PlayerResult])

    private enum CodingKeys: String, CodingKey { case type, payload }
    private enum Kind: String, Codable { case roster, startGame, tiltUpdate, standings, gameOver }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(Kind.self, forKey: .type) {
        case .roster:
            self = .roster(players: try container.decode([Player].self, forKey: .payload))
        case .startGame:
            self = .startGame(difficulty: try container.decode(DifficultyLevel.self, forKey: .payload))
        case .tiltUpdate:
            self = .tiltUpdate(result: try container.decode(PlayerResult.self, forKey: .payload))
        case .standings:
            self = .standings(entries: try container.decode([PlayerResult].self, forKey: .payload))
        case .gameOver:
            self = .gameOver(results: try container.decode([PlayerResult].self, forKey: .payload))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .roster(let players):
            try container.encode(Kind.roster, forKey: .type)
            try container.encode(players, forKey: .payload)
        case .startGame(let difficulty):
            try container.encode(Kind.startGame, forKey: .type)
            try container.encode(difficulty, forKey: .payload)
        case .tiltUpdate(let result):
            try container.encode(Kind.tiltUpdate, forKey: .type)
            try container.encode(result, forKey: .payload)
        case .standings(let entries):
            try container.encode(Kind.standings, forKey: .type)
            try container.encode(entries, forKey: .payload)
        case .gameOver(let results):
            try container.encode(Kind.gameOver, forKey: .type)
            try container.encode(results, forKey: .payload)
        }
    }
}
