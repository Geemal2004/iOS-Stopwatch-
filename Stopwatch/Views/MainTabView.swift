import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var homeViewModel = HomeViewModel()

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .environmentObject(homeViewModel)
                    .tag(0)

                ScenesView()
                    .tag(1)

                DevicesView()
                    .environmentObject(homeViewModel)
                    .tag(2)

                SettingsView()
                    .tag(3)
            }

            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int

    let tabItems: [(icon: String, label: String)] = [
        ("house.fill", "Home"),
        ("sparkles", "Scenes"),
        ("switch.2", "Devices"),
        ("gearshape.fill", "Settings")
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<4) { index in
                Button {
                    selectedTab = index
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tabItems[index].icon)
                            .font(.system(size: 22))
                        Text(tabItems[index].label)
                            .font(.system(size: 11))
                    }
                    .foregroundColor(selectedTab == index ? AppTheme.primaryLight : AppTheme.textMuted)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
            }

            Button {
            } label: {
                Image(systemName: "mic.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 48, height: 48)
                    .background(AppTheme.primary)
                    .clipShape(Circle())
            }
            .offset(y: -8)
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
        .padding(.bottom, 4)
        .background(
            AppTheme.surface
                .opacity(0.95)
        )
        .overlay(alignment: .top) {
            Rectangle()
                .fill(AppTheme.surfaceLight)
                .frame(height: 0.5)
        }
    }
}
