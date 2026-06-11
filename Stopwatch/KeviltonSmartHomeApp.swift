import SwiftUI

@main
struct KeviltonSmartHomeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var authViewModel = AuthViewModel()

    init() {
        TuyaService.shared.initialize(
            appKey: Bundle.main.object(forInfoDictionaryKey: "THING_SMART_APPKEY") as? String ?? "",
            secretKey: Bundle.main.object(forInfoDictionaryKey: "THING_SMART_SECRET") as? String ?? ""
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .preferredColorScheme(.dark)
        }
    }
}
