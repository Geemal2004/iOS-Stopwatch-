import Foundation
#if canImport(ThingSmartHomeKit)
import ThingSmartHomeKit
#endif

class DeviceService {
    static let shared = DeviceService()

    private init() {}

    func fetchDevices(for homeId: Int64, completion: @escaping ([Device]) -> Void) {
        #if canImport(ThingSmartHomeKit)
        let home = ThingSmartHome(homeId: homeId)
        home?.getHomeDetail({
            guard let homeModel = home?.homeModel else {
                completion([])
                return
            }
            let devices = homeModel.devices.compactMap { self.mapToDevice($0, homeId: homeId) }
            completion(devices)
        }, failure: { _ in
            completion([])
        })
        #else
        completion([])
        #endif
    }

    #if canImport(ThingSmartHomeKit)
    private func mapToDevice(_ model: ThingSmartDeviceModel, homeId: Int64) -> Device? {
        let type = DeviceType(rawValue: model.deviceType?.lowercased() ?? "") ?? .unknown
        return Device(
            id: model.devId ?? UUID().uuidString,
            devId: model.devId ?? "",
            name: model.name ?? "Unknown Device",
            type: type,
            status: model.isOnline ? .online : .offline,
            isOn: model.isOnline,
            brightness: 100,
            roomName: model.roomName,
            homeId: homeId
        )
    }
    #endif
}

class HomeCacheService {
    static let shared = HomeCacheService()
    private let defaults = UserDefaults.standard

    private init() {}

    private enum Keys {
        static let cachedDevices = "cached_devices"
        static let cachedHomes = "cached_homes"
        static let selectedHomeId = "selected_home_id"
    }

    func cacheDevices(_ devices: [Device], for homeId: Int64) {
        let key = "\(Keys.cachedDevices)_\(homeId)"
        if let data = try? JSONEncoder().encode(devices) {
            defaults.set(data, forKey: key)
        }
    }

    func getCachedDevices(for homeId: Int64) -> [Device] {
        let key = "\(Keys.cachedDevices)_\(homeId)"
        guard let data = defaults.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([Device].self, from: data)) ?? []
    }

    var selectedHomeId: Int64 {
        get { Int64(defaults.integer(forKey: Keys.selectedHomeId)) }
        set { defaults.set(newValue, forKey: Keys.selectedHomeId) }
    }
}
