import Foundation

enum GameConfig {
    /// Hard technical ceiling for a reliable real-time MCSession (Apple's own guidance).
    static let maxPlayersHardCap = 8
    static let freeTierMaxPlayers = 3
    static let partyPackMaxPlayers = 8
}
