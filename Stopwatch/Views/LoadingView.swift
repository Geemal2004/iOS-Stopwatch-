import SwiftUI

struct LoadingView: View {
    @Binding var isActive: Bool
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var opacity = 0.0
    @State private var scale: CGFloat = 0.8

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            Image("ic_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .opacity(opacity)
                .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                opacity = 1.0
                scale = 1.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    isActive = false
                }
            }
        }
    }
}
