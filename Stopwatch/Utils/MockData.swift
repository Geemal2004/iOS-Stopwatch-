import Foundation

struct MockData {
    static let homes: [HomeInfo] = [
        HomeInfo(
            id: 1,
            name: "My Home",
            geoName: "New York, USA",
            lat: 40.7128,
            lon: -74.0060,
            rooms: [
                Room(id: 1, homeId: 1, name: "Living Room", devices: [
                    Device(id: "d1", devId: "dev001", name: "Main Light", type: .switch, status: .online, isOn: true, brightness: 100, roomName: "Living Room", homeId: 1),
                    Device(id: "d2", devId: "dev002", name: "Floor Lamp", type: .dimmer, status: .online, isOn: true, brightness: 65, roomName: "Living Room", homeId: 1),
                    Device(id: "d3", devId: "dev003", name: "TV Socket", type: .socket, status: .online, isOn: false, brightness: 0, roomName: "Living Room", homeId: 1)
                ]),
                Room(id: 2, homeId: 1, name: "Bedroom", devices: [
                    Device(id: "d4", devId: "dev004", name: "Ceiling Light", type: .switch, status: .online, isOn: false, brightness: 0, roomName: "Bedroom", homeId: 1),
                    Device(id: "d5", devId: "dev005", name: "Night Lamp", type: .dimmer, status: .online, isOn: true, brightness: 30, roomName: "Bedroom", homeId: 1)
                ]),
                Room(id: 3, homeId: 1, name: "Kitchen", devices: [
                    Device(id: "d6", devId: "dev006", name: "Main Light", type: .switch, status: .online, isOn: true, brightness: 100, roomName: "Kitchen", homeId: 1),
                    Device(id: "d7", devId: "dev007", name: "Counter Socket", type: .socket, status: .offline, isOn: false, brightness: 0, roomName: "Kitchen", homeId: 1)
                ])
            ]
        )
    ]

    static let scenes: [SmartScene] = [
        SmartScene(id: "s1", name: "Good Morning", isActive: true, devices: ["d1", "d4"], actions: [
            SceneAction(devId: "d1", actionType: "turnOn", value: AnyCodable(true)),
            SceneAction(devId: "d4", actionType: "brightness", value: AnyCodable(80))
        ]),
        SmartScene(id: "s2", name: "Movie Night", isActive: true, devices: ["d2", "d3"], actions: [
            SceneAction(devId: "d2", actionType: "brightness", value: AnyCodable(20)),
            SceneAction(devId: "d3", actionType: "turnOn", value: AnyCodable(true))
        ]),
        SmartScene(id: "s3", name: "Good Night", isActive: false, devices: ["d1", "d2", "d4", "d5"], actions: [
            SceneAction(devId: "d1", actionType: "turnOff", value: AnyCodable(false)),
            SceneAction(devId: "d2", actionType: "turnOff", value: AnyCodable(false)),
            SceneAction(devId: "d4", actionType: "turnOff", value: AnyCodable(false)),
            SceneAction(devId: "d5", actionType: "turnOff", value: AnyCodable(false))
        ])
    ]
}
