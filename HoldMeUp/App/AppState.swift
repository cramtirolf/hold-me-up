import SwiftUI
import MultipeerConnectivity

enum AppRoute: Equatable {
    case splash
    case onboarding
    case home
    case howToPlay
    case hostLobby
    case joinList
    case sharedLobby
    case gameplay(difficulty: DifficultyLevel)
    case results
    case support
}

@MainActor
final class AppState: ObservableObject {
    @Published var route: AppRoute = .splash
    @Published var multipeer: MultipeerService?
    @Published var gameSession: GameSessionController?
    @Published var maxPlayersAllowed = GameConfig.freeTierMaxPlayers

    let profileStore = PlayerProfileStore()
    let storeService = StoreService()

    func goHomeIfProfileExists() {
        route = profileStore.profile != nil ? .home : .onboarding
    }

    /// Begins advertising the lobby. Does not start gameplay — see `startGameAsHost`.
    func startHosting(difficulty: DifficultyLevel) {
        guard let profile = profileStore.profile else { return }
        let service = MultipeerService(profile: profile)
        service.startHosting(profile: profile, maxPlayers: maxPlayersAllowed, difficulty: difficulty)
        multipeer = service
    }

    /// Host taps "Start Game": notify every joiner, then begin locally.
    func startGameAsHost(difficulty: DifficultyLevel) {
        guard let multipeer, multipeer.isHost else { return }
        multipeer.broadcast(.startGame(difficulty: difficulty))
        beginGameplay(difficulty: difficulty)
    }

    func startBrowsing() {
        guard let profile = profileStore.profile else { return }
        let service = MultipeerService(profile: profile)
        service.startBrowsing()
        multipeer = service
        route = .joinList
    }

    func joinGame(peerID: MCPeerID) {
        guard let profile = profileStore.profile, let multipeer else { return }
        multipeer.join(peerID: peerID, myProfile: profile)
        route = .sharedLobby
    }

    /// Called by everyone (host directly, joiners on receiving `.startGame`).
    func beginGameplay(difficulty: DifficultyLevel) {
        guard let profile = profileStore.profile, let multipeer else { return }
        let session = GameSessionController(difficulty: difficulty, multipeer: multipeer, myProfile: profile)
        gameSession = session
        route = .gameplay(difficulty: difficulty)
        session.start()
    }

    func leaveGame() {
        gameSession?.stop()
        gameSession = nil
        multipeer?.disconnect()
        multipeer = nil
        route = .home
    }
}
