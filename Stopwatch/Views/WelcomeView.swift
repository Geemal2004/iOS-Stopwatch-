import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var currentPage = 0
    @State private var showLogin = false
    @State private var showRegister = false

    let images = ["slider_1", "slider_2", "slider_3"]
    let tagline = "Smart Home can change\nthe way you live in the future"

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Image("ic_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180)
                    .padding(.top, 80)

                Spacer().frame(height: 40)

                TabView(selection: $currentPage) {
                    ForEach(0..<3) { index in
                        Image(images[index])
                            .resizable()
                            .scaledToFit()
                            .frame(height: 280)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 300)

                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(currentPage == index ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 16)

                Text(tagline)
                    .font(.system(size: 16))
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
                    .padding(.top, 24)

                Spacer()

                VStack(spacing: 16) {
                    Button("Get Started") {
                        showRegister = true
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.horizontal, 32)

                    Button("Already have an account? Sign In") {
                        showLogin = true
                    }
                    .foregroundColor(AppTheme.textSecondary)
                    .font(.system(size: 15))
                }
                .padding(.bottom, 50)
            }
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView()
                .environmentObject(authViewModel)
        }
        .fullScreenCover(isPresented: $showRegister) {
            RegisterView()
                .environmentObject(authViewModel)
        }
    }
}
