import Foundation
import Combine

/// Runs the actual game loop. Host-authoritative: the host aggregates every
/// player's tilt state, owns the countdown, decides eliminations/winner, and
/// broadcasts standings + final results. Joiners just read their own motion
/// and report it — see CLAUDE.md "Architecture".
@MainActor
final class GameSessionController: ObservableObject {
    @Published private(set) var timeRemaining: TimeInterval
    @Published private(set) var standings: [PlayerResult] = []
    @Published private(set) var finalResults: [PlayerResult]?
    @Published private(set) var myTiltDegrees: Double = 0
    @Published private(set) var myTiltX: Double = 0
    @Published private(set) var myTiltY: Double = 0
    @Published private(set) var amIEliminated = false

    let difficulty: DifficultyLevel
    let motion = MotionService()

    private let multipeer: MultipeerService
    private let myProfile: PlayerProfile
    private var latestByPlayer: [String: PlayerResult] = [:]
    private var timer: Timer?
    private var lastTick = Date()
    private var myFlatDuration: TimeInterval = 0
    private var myMaxTilt: Double = 0
    private var cancellables = Set<AnyCancellable>()

    init(difficulty: DifficultyLevel, multipeer: MultipeerService, myProfile: PlayerProfile) {
        self.difficulty = difficulty
        self.multipeer = multipeer
        self.myProfile = myProfile
        self.timeRemaining = TimeInterval(difficulty.durationSeconds)
        observeIncomingMessages()
    }

    func start() {
        motion.start()
        lastTick = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tick() }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        motion.stop()
    }

    private func tick() {
        let now = Date()
        let delta = now.timeIntervalSince(lastTick)
        lastTick = now

        myTiltDegrees = motion.tiltDegrees
        myTiltX = motion.tiltX
        myTiltY = motion.tiltY

        if !amIEliminated {
            myMaxTilt = max(myMaxTilt, myTiltDegrees)
            if myTiltDegrees <= difficulty.toleranceDegrees {
                myFlatDuration += delta
            } else {
                amIEliminated = true
            }
        }

        let myResult = PlayerResult(id: multipeer.myID, nickname: myProfile.nickname, avatar: myProfile.avatar, flatDuration: myFlatDuration, maxTiltDegrees: myMaxTilt, eliminated: amIEliminated)

        if multipeer.isHost {
            latestByPlayer[myResult.id] = myResult
            timeRemaining = max(0, timeRemaining - delta)
            let entries = Array(latestByPlayer.values)
            standings = entries
            multipeer.broadcast(.standings(entries: entries))
            checkForGameEnd()
        } else {
            multipeer.broadcast(.tiltUpdate(result: myResult))
        }
    }

    private func checkForGameEnd() {
        guard finalResults == nil else { return }
        let active = latestByPlayer.values.filter { !$0.eliminated }
        guard timeRemaining <= 0 || active.count <= 1 else { return }
        let results = latestByPlayer.values.sorted { $0.flatDuration > $1.flatDuration }
        finalResults = results
        multipeer.broadcast(.gameOver(results: results))
        stop()
    }

    private func observeIncomingMessages() {
        multipeer.$lastMessage
            .compactMap { $0 }
            .sink { [weak self] message in
                guard let self else { return }
                switch message {
                case .tiltUpdate(let result):
                    guard self.multipeer.isHost else { return }
                    self.latestByPlayer[result.id] = result
                case .standings(let entries):
                    guard !self.multipeer.isHost else { return }
                    self.standings = entries
                case .gameOver(let results):
                    self.finalResults = results
                    self.stop()
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
