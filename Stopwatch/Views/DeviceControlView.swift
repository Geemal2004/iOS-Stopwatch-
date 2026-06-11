import SwiftUI

struct DeviceControlView: View {
    let device: Device
    @EnvironmentObject var homeViewModel: HomeViewModel
    @StateObject private var deviceViewModel: DeviceViewModel
    @Environment(\.dismiss) var dismiss

    init(device: Device) {
        self.device = device
        _deviceViewModel = StateObject(wrappedValue: DeviceViewModel(device: device))
    }

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    deviceHeader
                    powerToggle
                    if device.type == .dimmer {
                        brightnessControl
                    }
                    deviceInfo
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(device.name)
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
    }

    private var deviceHeader: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(deviceViewModel.isOn ? AppTheme.primary.opacity(0.2) : AppTheme.surface)
                    .frame(width: 160, height: 160)

                Circle()
                    .stroke(deviceViewModel.isOn ? AppTheme.primaryLight : AppTheme.surfaceLight, lineWidth: 3)
                    .frame(width: 140, height: 140)

                Image(systemName: deviceIcon)
                    .font(.system(size: 60))
                    .foregroundColor(deviceViewModel.isOn ? AppTheme.primaryLight : AppTheme.textMuted)
            }
            .padding(.top, 20)

            Text(deviceViewModel.isOn ? "Powered On" : "Powered Off")
                .font(.system(size: 16))
                .foregroundColor(deviceViewModel.isOn ? AppTheme.success : AppTheme.textMuted)
        }
    }

    private var powerToggle: some View {
        VStack(spacing: 12) {
            Text("Power")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                deviceViewModel.togglePower()
                homeViewModel.toggleDevice(device)
            } label: {
                HStack {
                    Image(systemName: deviceViewModel.isOn ? "power.circle.fill" : "power.circle")
                        .font(.title2)
                    Text(deviceViewModel.isOn ? "Turn Off" : "Turn On")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(deviceViewModel.isOn ? AppTheme.surfaceLight : AppTheme.primary)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    private var brightnessControl: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Brightness")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
                Spacer()
                Text("\(Int(deviceViewModel.brightness))%")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }

            VStack {
                Slider(value: $deviceViewModel.brightness, in: 1...100, step: 1)
                    .accentColor(AppTheme.primaryLight)
                    .onChange(of: deviceViewModel.brightness) { newValue in
                        homeViewModel.updateBrightness(for: device.devId, brightness: Int(newValue))
                    }

                HStack {
                    Image(systemName: "sun.min")
                        .foregroundColor(AppTheme.textMuted)
                        .font(.caption)
                    Spacer()
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(AppTheme.primaryLight)
                        .font(.caption)
                }
            }
        }
        .padding(20)
        .background(AppTheme.surface)
        .cornerRadius(16)
    }

    private var deviceInfo: some View {
        VStack(spacing: 12) {
            Text("Device Info")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            infoRow(label: "Status", value: device.status == .online ? "Online" : "Offline")
            infoRow(label: "Room", value: device.roomName ?? "Unassigned")
            infoRow(label: "Device ID", value: device.devId)
            infoRow(label: "Type", value: device.type.rawValue.capitalized)
        }
        .padding(20)
        .background(AppTheme.surface)
        .cornerRadius(16)
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textSecondary)
            Spacer()
            Text(value)
                .font(.system(size: 14))
                .foregroundColor(.white)
        }
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
