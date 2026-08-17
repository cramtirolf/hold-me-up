import Testing
@testable import holdmeup

struct PartyPackTierStateTests {

    @Test func lockedAtFreeTierCap() {
        #expect(partyPackTierState(maxPlayersAllowed: GameConfig.freeTierMaxPlayers) == .locked)
    }

    @Test func unlockedAtPartyPackCap() {
        #expect(partyPackTierState(maxPlayersAllowed: GameConfig.partyPackMaxPlayers) == .unlocked)
    }

    @Test func lockedJustBelowPartyPackCap() {
        #expect(partyPackTierState(maxPlayersAllowed: GameConfig.partyPackMaxPlayers - 1) == .locked)
    }

    @Test func unlockedAboveThePartyPackCap() {
        #expect(partyPackTierState(maxPlayersAllowed: GameConfig.partyPackMaxPlayers + 1) == .unlocked)
    }
}
