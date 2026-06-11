import Foundation

enum DeviceType: String, Codable, CaseIterable {
    case `switch` = "switch"
    case dimmer = "dimmer"
    case socket = "socket"
    case unknown = "unknown"
}

enum DeviceStatus: String, Codable {
    case online = "online"
    case offline = "offline"
}

struct Device: Identifiable, Codable {
    let id: String
    let devId: String
    var name: String
    let type: DeviceType
    var status: DeviceStatus
    var isOn: Bool
    var brightness: Int
    var roomName: String?
    var homeId: Int64

    static let mockSwitch = Device(
        id: "1", devId: "dev001", name: "Living Room Light",
        type: .switch, status: .online, isOn: true, brightness: 100,
        roomName: "Living Room", homeId: 1
    )

    static let mockDimmer = Device(
        id: "2", devId: "dev002", name: "Bedroom Dimmer",
        type: .dimmer, status: .online, isOn: true, brightness: 70,
        roomName: "Bedroom", homeId: 1
    )

    static let mockSocket = Device(
        id: "3", devId: "dev003", name: "Kitchen Socket",
        type: .socket, status: .offline, isOn: false, brightness: 0,
        roomName: "Kitchen", homeId: 1
    )
}

struct Room: Identifiable, Codable {
    let id: Int64
    let homeId: Int64
    var name: String
    var devices: [Device]

    static let mock = Room(
        id: 1, homeId: 1, name: "Living Room",
        devices: [Device.mockSwitch, Device.mockDimmer]
    )
}

struct HomeInfo: Identifiable, Codable {
    let id: Int64
    var name: String
    var geoName: String
    var lat: Double
    var lon: Double
    var rooms: [Room]?
}
