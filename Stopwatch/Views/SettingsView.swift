import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showProfile = false
    @State private var showHomeManagement = false
    @State private var showDeviceManagement = false
    @State private var showRoomManagement = false
    @State private var showColorConfig = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        headerView
                        profileCard
                        settingsSections
                        logoutButton
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showProfile) {
                ProfileView()
                    .environmentObject(authViewModel)
            }
        }
    }

    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Settings")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                Text("Manage your home and account")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.textSecondary)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 60)
    }

    private var profileCard: some View {
        Button {
            showProfile = true
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppTheme.primary)
                        .frame(width: 56, height: 56)

                    Text(authViewModel.authState.user?.nickname.prefix(1).uppercased() ?? "U")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(authViewModel.authState.user?.nickname ?? "User")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    Text(authViewModel.authState.user?.email ?? "user@example.com")
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(AppTheme.textMuted)
            }
            .padding(16)
            .background(AppTheme.surface)
            .cornerRadius(16)
        }
        .padding(.horizontal, 20)
    }

    private var settingsSections: some View {
        VStack(spacing: 12) {
            settingsButton(icon: "house.fill", title: "Home Management", action: { showHomeManagement = true })
            settingsButton(icon: "switch.2", title: "Device Management", action: { showDeviceManagement = true })
            settingsButton(icon: "square.grid.2x2", title: "Room Management", action: { showRoomManagement = true })
            settingsButton(icon: "paintpalette.fill", title: "Color Configuration", action: { showColorConfig = true })
            settingsButton(icon: "arrow.triangle.swap", title: "Transfer Device", action: {})
            settingsButton(icon: "person.2.fill", title: "Member Settings", action: {})
            settingsButton(icon: "globe", title: "Change Time Zone", action: {})
            settingsButton(icon: "map.fill", title: "Location Settings", action: {})
            settingsButton(icon: "info.circle.fill", title: "About", action: {})
        }
        .padding(.horizontal, 20)
    }

    private func settingsButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(AppTheme.primaryLight)
                    .frame(width: 24)

                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppTheme.textMuted)
            }
            .padding(16)
            .background(AppTheme.surface)
            .cornerRadius(12)
        }
    }

    private var logoutButton: some View {
        Button(role: .destructive) {
            authViewModel.logout()
        } label: {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Sign Out")
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(AppTheme.surface)
            .foregroundColor(.red)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
}

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var nickname = ""

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            VStack(spacing: 24) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("Profile")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                ZStack {
                    Circle()
                        .fill(AppTheme.primary)
                        .frame(width: 100, height: 100)

                    Text(authViewModel.authState.user?.nickname.prefix(2).uppercased() ?? "U")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                }

                VStack(spacing: 16) {
                    profileField(label: "Nickname", value: authViewModel.authState.user?.nickname ?? "User")
                    profileField(label: "Email", value: authViewModel.authState.user?.email ?? "")
                    profileField(label: "Country Code", value: "+\(authViewModel.authState.user?.countryCode ?? "1")")
                    profileField(label: "Timezone", value: authViewModel.authState.user?.timezoneId ?? "America/New_York")
                }
                .padding(.horizontal, 20)

                Spacer()
            }
        }
    }

    private func profileField(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textSecondary)
            Spacer()
            Text(value)
                .font(.system(size: 16))
                .foregroundColor(.white)
        }
        .padding(16)
        .background(AppTheme.surface)
        .cornerRadius(12)
    }
}
