import SwiftUI

struct HomeView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showRoomSelector = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        headerView
                        roomChipsView
                        devicesGrid
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showRoomSelector) {
                roomSelectorSheet
            }
        }
    }

    private var headerView: some View {
        VStack(spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    if let home = homeViewModel.selectedHome {
                        Text(home.name)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        Text(home.geoName)
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }

                Spacer()

                Button {
                    showRoomSelector = true
                } label: {
                    Image(systemName: "house.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(AppTheme.primaryLight)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 60)

            HStack(spacing: 32) {
                statView(count: homeViewModel.onlineDevices.count, label: "Online")
                statView(count: homeViewModel.offlineDevices.count, label: "Offline")
                statView(count: homeViewModel.rooms.count, label: "Rooms")
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(AppTheme.surface)
            .cornerRadius(16)
            .padding(.horizontal, 20)
        }
    }

    private func statView(count: Int, label: String) -> some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var roomChipsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Button {
                    homeViewModel.selectRoom(nil)
                } label: {
                    Text("All")
                        .font(.system(size: 14, weight: .medium))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(homeViewModel.selectedRoom == nil ? AppTheme.primary : AppTheme.surfaceLight)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }

                ForEach(homeViewModel.rooms) { room in
                    Button {
                        homeViewModel.selectRoom(room)
                    } label: {
                        Text(room.name)
                            .font(.system(size: 14, weight: .medium))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(homeViewModel.selectedRoom?.id == room.id ? AppTheme.primary : AppTheme.surfaceLight)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private var devicesGrid: some View {
        let devices = homeViewModel.selectedRoom?.devices ?? homeViewModel.allDevices
        return LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(devices) { device in
                NavigationLink {
                    DeviceControlView(device: device)
                        .environmentObject(homeViewModel)
                } label: {
                    DeviceCardView(device: device)
                }
            }
        }
        .padding(.horizontal, 20)
    }

    private var roomSelectorSheet: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 16) {
                Text("Select Home")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .padding(.top, 20)

                ForEach(homeViewModel.homes) { home in
                    Button {
                        homeViewModel.selectHome(home)
                        showRoomSelector = false
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(home.name)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text(home.geoName)
                                    .font(.caption)
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            Spacer()
                            if home.id == homeViewModel.selectedHome?.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(AppTheme.primaryLight)
                            }
                        }
                        .padding()
                        .background(AppTheme.surface)
                        .cornerRadius(12)
                    }
                }
                Spacer()
            }
            .padding()
        }
        .presentationDetents([.medium])
    }
}

struct DeviceCardView: View {
    let device: Device

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: deviceIcon)
                    .font(.system(size: 28))
                    .foregroundColor(device.isOn ? AppTheme.primaryLight : AppTheme.textMuted)

                Spacer()

                Circle()
                    .fill(device.status == .online ? AppTheme.success : AppTheme.textMuted)
                    .frame(width: 8, height: 8)
            }

            Text(device.name)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(1)

            HStack {
                if device.type == .dimmer {
                    Text("\(device.brightness)%")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textSecondary)
                }

                Spacer()

                Text(device.isOn ? "ON" : "OFF")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(device.isOn ? AppTheme.success : AppTheme.textMuted)
            }
        }
        .padding(16)
        .background(AppTheme.surface)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(device.isOn ? AppTheme.primary.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }

    private var deviceIcon: String {
        switch device.type {
        case .switch: return "lightbulb.fill"
        case .dimmer: return "dial.min.fill"
        case .socket: return "powerplug.fill"
        case .unknown: return "questionmark.circle"
        }
    }
}
