import SwiftUI

struct HowToPlayFlowView: View {
    @EnvironmentObject var appState: AppState
    @State private var page = 0

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button { appState.route = .home } label: { Image(systemName: "chevron.left") }
                Spacer()
                Text("How to Play · \(page + 1) of 4")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Theme.inkFaint)
                Spacer()
                Button {
                    switch HowToPlayFlowView.nextStep(afterPage: page) {
                    case .page(let nextPage): page = nextPage
                    case .exitToHome: appState.route = .home
                    }
                } label: { Image(systemName: "chevron.right") }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)

            TabView(selection: $page) {
                HowToPlayChallengeView().tag(0)
                HowToPlayBullseyeView().tag(1)
                HowToPlayEliminationView().tag(2)
                HowToPlayWinningView().tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
        .background(Theme.background.ignoresSafeArea())
    }
}

enum HowToPlayNavigation: Equatable {
    case page(Int)
    case exitToHome
}

extension HowToPlayFlowView {
    static func nextStep(afterPage page: Int, lastPageIndex: Int = 3) -> HowToPlayNavigation {
        page < lastPageIndex ? .page(page + 1) : .exitToHome
    }
}
