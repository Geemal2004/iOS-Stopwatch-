import Foundation
#if canImport(ThingSmartHomeKit)
import ThingSmartHomeKit
#endif

class TuyaService {
    static let shared = TuyaService()

    private init() {}

    func initialize() {
        #if canImport(ThingSmartHomeKit)
        let appKey = Bundle.main.object(forInfoDictionaryKey: "THING_SMART_APPKEY") as? String ?? ""
        let secretKey = Bundle.main.object(forInfoDictionaryKey: "THING_SMART_SECRET") as? String ?? ""
        ThingSmartSDK.sharedInstance()?.start(withAppKey: appKey, secretKey: secretKey)
        #if DEBUG
        ThingSmartSDK.sharedInstance()?.debugMode = true
        #endif
        #endif
    }
}

class AuthService {
    static let shared = AuthService()

    private init() {}

    var isLoggedIn: Bool {
        #if canImport(ThingSmartHomeKit)
        return ThingSmartUser.sharedInstance().isLogin
        #else
        return UserDefaults.standard.getSavedUser() != nil
        #endif
    }

    func login(email: String, password: String, countryCode: String = "1", completion: @escaping (Result<User, Error>) -> Void) {
        #if canImport(ThingSmartHomeKit)
        ThingSmartUser.sharedInstance()?.login(
            byEmail: countryCode,
            email: email,
            password: password
        ) { [weak self] in
            guard let thingUser = ThingSmartUser.sharedInstance() else {
                completion(.failure(TuyaError.userNotFound))
                return
            }
            let user = User(
                id: thingUser.sid ?? "",
                nickname: thingUser.nickName ?? "",
                email: email,
                phone: nil,
                avatarUrl: thingUser.headIconUrl,
                countryCode: countryCode,
                timezoneId: thingUser.timezoneId ?? "America/New_York"
            )
            UserDefaults.standard.saveUser(user)
            completion(.success(user))
        } failure: { error in
            completion(.failure(error ?? TuyaError.unknown))
        }
        #else
        let user = User(
            id: UUID().uuidString,
            nickname: email.components(separatedBy: "@").first ?? "User",
            email: email,
            phone: nil,
            avatarUrl: nil,
            countryCode: countryCode,
            timezoneId: "America/New_York"
        )
        UserDefaults.standard.saveUser(user)
        completion(.success(user))
        #endif
    }

    func register(email: String, password: String, countryCode: String = "1", completion: @escaping (Result<Void, Error>) -> Void) {
        #if canImport(ThingSmartHomeKit)
        ThingSmartUser.sharedInstance()?.register(
            byEmail: countryCode,
            email: email,
            password: password
        ) {
            completion(.success(()))
        } failure: { error in
            completion(.failure(error ?? TuyaError.unknown))
        }
        #else
        completion(.success(()))
        #endif
    }

    func verifyOTP(email: String, code: String, countryCode: String = "1", completion: @escaping (Result<Void, Error>) -> Void) {
        #if canImport(ThingSmartHomeKit)
        ThingSmartUser.sharedInstance()?.register(
            byEmail: countryCode,
            email: email,
            password: "",
            code: code
        ) {
            completion(.success(()))
        } failure: { error in
            completion(.failure(error ?? TuyaError.unknown))
        }
        #else
        completion(.success(()))
        #endif
    }

    func logout() {
        #if canImport(ThingSmartHomeKit)
        ThingSmartUser.sharedInstance()?.loginOut({
        }) { error in
        }
        #endif
        UserDefaults.standard.clearUser()
    }
}

enum TuyaError: LocalizedError {
    case userNotFound
    case unknown

    var errorDescription: String? {
        switch self {
        case .userNotFound: return "User not found"
        case .unknown: return "An unknown error occurred"
        }
    }
}

extension UserDefaults {
    private enum Keys {
        static let savedUser = "saved_user"
    }

    func saveUser(_ user: User) {
        if let data = try? JSONEncoder().encode(user) {
            set(data, forKey: Keys.savedUser)
            synchronize()
        }
    }

    func getSavedUser() -> User? {
        guard let data = data(forKey: Keys.savedUser) else { return nil }
        return try? JSONDecoder().decode(User.self, from: data)
    }

    func clearUser() {
        removeObject(forKey: Keys.savedUser)
        synchronize()
    }
}
