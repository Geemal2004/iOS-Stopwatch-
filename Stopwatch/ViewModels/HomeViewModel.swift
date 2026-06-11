import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var homes: [HomeInfo] = []
    @Published var selectedHome: HomeInfo?
    @Published var selectedRoom: Room?
    @Published var isLoading = false
    @Published var error: String?

    var allDevices: [Device] {
        selectedHome?.rooms?.flatMap { $0.devices } ?? []
    }

    var onlineDevices: [Device] {
        allDevices.filter { $0.status == .online }
    }

    var offlineDevices: [Device] {
        allDevices.filter { $0.status == .offline }
    }

    var rooms: [Room] {
        selectedHome?.rooms ?? []
    }

    init() {
        loadMockData()
    }

    func loadMockData() {
        homes = MockData.homes
        selectedHome = homes.first
    }

    func selectHome(_ home: HomeInfo) {
        selectedHome = home
        HomeCacheService.shared.selectedHomeId = home.id
    }

    func selectRoom(_ room: Room?) {
        selectedRoom = room
    }

    func toggleDevice(_ device: Device) {
        guard let home = selectedHome,
              let roomIndex = home.rooms?.firstIndex(where: { $0.devices.contains(where: { $0.id == device.id }) }),
              let deviceIndex = home.rooms?[roomIndex].devices.firstIndex(where: { $0.id == device.id })
        else { return }

        homes[0].rooms?[roomIndex].devices[deviceIndex].isOn.toggle()
        if let updatedHome = homes.first {
            selectedHome = updatedHome
        }
    }

    func updateBrightness(for deviceId: String, brightness: Int) {
        guard let home = selectedHome,
              let roomIndex = home.rooms?.firstIndex(where: { $0.devices.contains(where: { $0.id == deviceId }) }),
              let deviceIndex = home.rooms?[roomIndex].devices.firstIndex(where: { $0.id == deviceId })
        else { return }

        homes[0].rooms?[roomIndex].devices[deviceIndex].brightness = brightness
    }
}
