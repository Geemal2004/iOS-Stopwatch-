import SwiftUI

struct ScenesView: View {
    @State private var scenes: [SmartScene] = MockData.scenes
    @State private var showCreateScene = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        headerView

                        if scenes.isEmpty {
                            emptyStateView
                        } else {
                            scenesList
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showCreateScene) {
                CreateSceneView { scene in
                    scenes.append(scene)
                }
            }
        }
    }

    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Scenes")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                Text("Automate your home")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.textSecondary)
            }
            Spacer()

            Button {
                showCreateScene = true
            } label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(AppTheme.primary)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 60)
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.textMuted)

            Text("No Scenes Yet")
                .font(.title3.bold())
                .foregroundColor(.white)

            Text("Create your first scene to automate\nyour smart home devices")
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)

            Button {
                showCreateScene = true
            } label: {
                Text("Create Scene")
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, 40)
            .padding(.top, 8)
        }
        .padding(.top, 60)
    }

    private var scenesList: some View {
        LazyVStack(spacing: 12) {
            ForEach(scenes) { scene in
                SceneCardView(scene: scene)
            }
        }
        .padding(.horizontal, 20)
    }
}

struct SceneCardView: View {
    let scene: SmartScene
    @State private var isActive: Bool

    init(scene: SmartScene) {
        self.scene = scene
        _isActive = State(initialValue: scene.isActive)
    }

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isActive ? AppTheme.primary.opacity(0.2) : AppTheme.surface)
                    .frame(width: 50, height: 50)

                Image(systemName: isActive ? "sparkles" : "sparkle")
                    .font(.title2)
                    .foregroundColor(isActive ? AppTheme.primaryLight : AppTheme.textMuted)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(scene.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                Text("\(scene.devices.count) devices")
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.textSecondary)
            }

            Spacer()

            Toggle("", isOn: $isActive)
                .labelsHidden()
                .tint(AppTheme.primaryLight)
        }
        .padding(16)
        .background(AppTheme.surface)
        .cornerRadius(16)
    }
}

struct CreateSceneView: View {
    @Environment(\.dismiss) var dismiss
    let onSave: (SmartScene) -> Void

    @State private var sceneName = ""
    @State private var selectedDeviceIds: Set<String> = []

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            VStack(spacing: 20) {
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.textSecondary)

                    Spacer()

                    Text("New Scene")
                        .font(.headline)
                        .foregroundColor(.white)

                    Spacer()

                    Button("Save") {
                        let scene = SmartScene(
                            id: UUID().uuidString,
                            name: sceneName,
                            isActive: true,
                            devices: Array(selectedDeviceIds),
                            actions: []
                        )
                        onSave(scene)
                        dismiss()
                    }
                    .foregroundColor(AppTheme.primaryLight)
                    .disabled(sceneName.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                TextField("Scene Name", text: $sceneName)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(AppTheme.surface)
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)

                Text("Select Devices")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)

                let mockDevices = Device.mockSwitch
                List {
                    ForEach([Device.mockSwitch, Device.mockDimmer, Device.mockSocket]) { device in
                        Button {
                            if selectedDeviceIds.contains(device.id) {
                                selectedDeviceIds.remove(device.id)
                            } else {
                                selectedDeviceIds.insert(device.id)
                            }
                        } label: {
                            HStack {
                                Image(systemName: deviceIcon(device.type))
                                    .foregroundColor(AppTheme.primaryLight)
                                Text(device.name)
                                    .foregroundColor(.white)
                                Spacer()
                                if selectedDeviceIds.contains(device.id) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(AppTheme.primaryLight)
                                }
                            }
                        }
                        .listRowBackground(AppTheme.surface)
                    }
                }
                .scrollContentBackground(.hidden)

                Spacer()
            }
        }
    }

    private func deviceIcon(_ type: DeviceType) -> String {
        switch type {
        case .switch: return "lightbulb.fill"
        case .dimmer: return "dial.min.fill"
        case .socket: return "powerplug.fill"
        case .unknown: return "questionmark.circle"
        }
    }
}
