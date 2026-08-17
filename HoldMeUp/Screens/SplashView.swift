import SwiftUI

struct SplashView: View {
    @EnvironmentObject var appState: AppState
    @State private var hasNavigated = false

    var body: some View {
        Image("IntroScreen")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.background)
            .ignoresSafeArea()
            .contentShape(Rectangle())
            .onTapGesture { proceed() }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    proceed()
                }
            }
    }

    private func proceed() {
        guard !hasNavigated else { return }
        hasNavigated = true
        appState.goHomeIfProfileExists()
    }
}
