import SwiftUI
import Combine

class DeviceViewModel: ObservableObject {
    @Published var device: Device
    @Published var isOn: Bool
    @Published var brightness: Double

    init(device: Device) {
        self.device = device
        self.isOn = device.isOn
        self.brightness = Double(device.brightness)
    }

    func togglePower() {
        isOn.toggle()
        device.isOn = isOn
    }

    func setBrightness(_ value: Double) {
        brightness = value
        device.brightness = Int(value)
    }
}
