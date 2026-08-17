import Testing
@testable import holdmeup

struct HowToPlayFlowViewTests {

    @Test func advancesToNextPageFromChallenge() {
        #expect(HowToPlayFlowView.nextStep(afterPage: 0) == .page(1))
    }

    @Test func advancesToNextPageFromBullseye() {
        #expect(HowToPlayFlowView.nextStep(afterPage: 1) == .page(2))
    }

    @Test func advancesToNextPageFromElimination() {
        #expect(HowToPlayFlowView.nextStep(afterPage: 2) == .page(3))
    }

    @Test func exitsToHomeFromLastPage() {
        #expect(HowToPlayFlowView.nextStep(afterPage: 3) == .exitToHome)
    }

    @Test func exitsToHomeRatherThanAdvancingPastLastPage() {
        let result = HowToPlayFlowView.nextStep(afterPage: 3)
        #expect(result != .page(4), "must not produce an out-of-bounds page index")
    }

    @Test func respectsCustomLastPageIndex() {
        #expect(HowToPlayFlowView.nextStep(afterPage: 0, lastPageIndex: 0) == .exitToHome)
    }
}
