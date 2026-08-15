import MultipeerConnectivity

/// Peer-to-peer networking over Wi-Fi/Bluetooth — no server, no internet
/// required. Star topology: the host advertises, joiners browse and invite
/// themselves into the host's session; joiners never connect to each other.
final class MultipeerService: NSObject, ObservableObject {
    static let serviceType = "holdmeup"

    enum ConnectionState: Equatable {
        case idle, hosting, browsing, connectingToHost, connected
    }

    struct DiscoveryInfo: Codable {
        var hostNickname: String
        var hostAvatar: AvatarOption
        var playerCount: Int
        var maxPlayers: Int
        var difficulty: DifficultyLevel
    }

    @Published private(set) var players: [Player] = []
    @Published private(set) var nearbyHosts: [MCPeerID: DiscoveryInfo] = [:]
    @Published private(set) var connectionState: ConnectionState = .idle
    @Published var lastMessage: GameMessage?

    private(set) var isHost = false
    private var currentMaxPlayers = GameConfig.freeTierMaxPlayers

    private let myPeerID: MCPeerID
    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?

    var myID: String { myPeerID.displayName }

    init(profile: PlayerProfile) {
        myPeerID = MCPeerID(displayName: profile.nickname)
        super.init()
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
    }

    // MARK: Hosting

    func startHosting(profile: PlayerProfile, maxPlayers: Int, difficulty: DifficultyLevel) {
        isHost = true
        currentMaxPlayers = maxPlayers
        players = [Player(id: myID, nickname: profile.nickname, avatar: profile.avatar, isHost: true)]

        let info = DiscoveryInfo(hostNickname: profile.nickname, hostAvatar: profile.avatar, playerCount: players.count, maxPlayers: maxPlayers, difficulty: difficulty)
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: Self.encode(info), serviceType: Self.serviceType)
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
        connectionState = .hosting
    }

    func stopHosting() {
        advertiser?.stopAdvertisingPeer()
        advertiser = nil
    }

    // MARK: Joining

    func startBrowsing() {
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: Self.serviceType)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
        connectionState = .browsing
    }

    func stopBrowsing() {
        browser?.stopBrowsingForPeers()
        browser = nil
    }

    func join(peerID: MCPeerID, myProfile: PlayerProfile) {
        guard let browser else { return }
        connectionState = .connectingToHost
        let context = try? JSONEncoder().encode(myProfile)
        browser.invitePeer(peerID, to: session, withContext: context, timeout: 15)
    }

    // MARK: Messaging

    func broadcast(_ message: GameMessage) {
        guard !session.connectedPeers.isEmpty, let data = try? JSONEncoder().encode(message) else { return }
        try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }

    func disconnect() {
        session.disconnect()
        stopHosting()
        stopBrowsing()
        players = []
        nearbyHosts = [:]
        connectionState = .idle
        isHost = false
    }

    private func broadcastRoster() {
        broadcast(.roster(players: players))
    }

    private static func encode(_ info: DiscoveryInfo) -> [String: String] {
        guard let data = try? JSONEncoder().encode(info), let json = String(data: data, encoding: .utf8) else { return [:] }
        return ["info": json]
    }
}

// MARK: - MCSessionDelegate

extension MultipeerService: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
            case .connected:
                if !self.isHost { self.connectionState = .connected }
            case .notConnected:
                if self.isHost {
                    self.players.removeAll { $0.id == peerID.displayName }
                    self.broadcastRoster()
                }
            default:
                break
            }
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let message = try? JSONDecoder().decode(GameMessage.self, from: data) else { return }
        DispatchQueue.main.async {
            if case .roster(let players) = message {
                self.players = players
            }
            self.lastMessage = message
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

// MARK: - MCNearbyServiceAdvertiserDelegate

extension MultipeerService: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        guard players.count < currentMaxPlayers,
              let context, let profile = try? JSONDecoder().decode(PlayerProfile.self, from: context) else {
            invitationHandler(false, nil)
            return
        }
        DispatchQueue.main.async {
            self.players.append(Player(id: peerID.displayName, nickname: profile.nickname, avatar: profile.avatar, isHost: false))
            self.broadcastRoster()
        }
        invitationHandler(true, session)
    }
}

// MARK: - MCNearbyServiceBrowserDelegate

extension MultipeerService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        guard let json = info?["info"], let data = json.data(using: .utf8),
              let decoded = try? JSONDecoder().decode(DiscoveryInfo.self, from: data) else { return }
        DispatchQueue.main.async { self.nearbyHosts[peerID] = decoded }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async { self.nearbyHosts.removeValue(forKey: peerID) }
    }
}
