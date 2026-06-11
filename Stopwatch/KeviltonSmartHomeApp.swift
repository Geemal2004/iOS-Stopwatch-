import SwiftUI

@main
struct KeviltonSmartHomeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var authViewModel = AuthViewModel()

    init() {
        TuyaService.shared.initialize()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .preferredColorScheme(.dark)
        }
    }
}
