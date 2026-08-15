import Foundation

struct PlayerProfile: Codable, Equatable {
    var nickname: String
    var avatar: AvatarOption
}

/// Local-only identity — no accounts, no server. Saved once in onboarding.
final class PlayerProfileStore: ObservableObject {
    @Published private(set) var profile: PlayerProfile?

    private let defaultsKey = "com.holdmeup.playerProfile"

    init() {
        load()
    }

    func save(nickname: String, avatar: AvatarOption) {
        let trimmed = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        let newProfile = PlayerProfile(nickname: trimmed, avatar: avatar)
        profile = newProfile
        if let data = try? JSONEncoder().encode(newProfile) {
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: defaultsKey),
              let decoded = try? JSONDecoder().decode(PlayerProfile.self, from: data) else { return }
        profile = decoded
    }
}
