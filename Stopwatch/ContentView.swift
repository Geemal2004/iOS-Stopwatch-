import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSplash = true

    var body: some View {
        Group {
            if showSplash {
                LoadingView(isActive: $showSplash)
            } else if authViewModel.authState.isLoggedIn {
                MainTabView()
                    .environmentObject(authViewModel)
            } else {
                WelcomeView()
                    .environmentObject(authViewModel)
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.5), value: showSplash)
        .animation(.easeInOut(duration: 0.3), value: authViewModel.authState.isLoggedIn)
    }
}
