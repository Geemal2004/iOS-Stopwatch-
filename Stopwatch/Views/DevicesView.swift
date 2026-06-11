import SwiftUI

struct DevicesView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var searchText = ""

    var filteredDevices: [Device] {
        let devices = homeViewModel.allDevices
        if searchText.isEmpty {
            return devices
        }
        return devices.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var groupedDevices: [(String, [Device])] {
        Dictionary(grouping: filteredDevices) { $0.roomName ?? "Other" }
            .map { ($0.key, $0.value) }
            .sorted { $0.0 < $1.0 }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        headerView
                        searchBar

                        if filteredDevices.isEmpty {
                            emptyStateView
                        } else {
                            devicesByRoom
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationBarHidden(true)
        }
    }

    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Devices")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                Text("\(homeViewModel.allDevices.count) total devices")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.textSecondary)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 60)
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppTheme.textMuted)
            TextField("Search devices...", text: $searchText)
                .textFieldStyle(.plain)
                .foregroundColor(.white)
        }
        .padding(12)
        .background(AppTheme.surface)
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.textMuted)

            Text("No Devices Found")
                .font(.title3.bold())
                .foregroundColor(.white)

            Text(searchText.isEmpty ? "Add a device to get started" : "No devices matching \"\(searchText)\"")
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textSecondary)
        }
        .padding(.top, 60)
    }

    private var devicesByRoom: some View {
        ForEach(groupedDevices, id: \.0) { room, devices in
            VStack(alignment: .leading, spacing: 8) {
                Text(room)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)

                ForEach(devices) { device in
                    NavigationLink {
                        DeviceControlView(device: device)
                            .environmentObject(homeViewModel)
                    } label: {
                        DeviceListItemView(device: device)
                    }
                }
            }
        }
    }
}

struct DeviceListItemView: View {
    let device: Device

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(device.isOn ? AppTheme.primary.opacity(0.2) : AppTheme.surfaceLight)
                    .frame(width: 48, height: 48)

                Image(systemName: deviceIcon)
                    .font(.system(size: 22))
                    .foregroundColor(device.isOn ? AppTheme.primaryLight : AppTheme.textMuted)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(device.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                HStack(spacing: 8) {
                    Circle()
                        .fill(device.status == .online ? AppTheme.success : AppTheme.textMuted)
                        .frame(width: 6, height: 6)
                    Text(device.status == .online ? "Online" : "Offline")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textSecondary)
                    if device.type == .dimmer {
                        Text("• \(device.brightness)%")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(AppTheme.textMuted)
        }
        .padding(16)
        .background(AppTheme.surface)
        .cornerRadius(16)
        .padding(.horizontal, 20)
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
