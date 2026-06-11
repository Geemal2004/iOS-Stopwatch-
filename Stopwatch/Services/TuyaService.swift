import Foundation
import ThingSmartHomeKit

class TuyaService {
    static let shared = TuyaService()

    private init() {}

    func initialize(appKey: String, secretKey: String) {
        ThingSmartSDK.sharedInstance()?.start(withAppKey: appKey, secretKey: secretKey)
        #if DEBUG
        ThingSmartSDK.sharedInstance()?.debugMode = true
        #endif
    }
}

class AuthService {
    static let shared = AuthService()

    private init() {}

    var isLoggedIn: Bool {
        ThingSmartUser.sharedInstance().isLogin
    }

    func login(email: String, password: String, countryCode: String = "1", completion: @escaping (Result<User, Error>) -> Void) {
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
    }

    func register(email: String, password: String, countryCode: String = "1", completion: @escaping (Result<Void, Error>) -> Void) {
        ThingSmartUser.sharedInstance()?.register(
            byEmail: countryCode,
            email: email,
            password: password
        ) {
            completion(.success(()))
        } failure: { error in
            completion(.failure(error ?? TuyaError.unknown))
        }
    }

    func verifyOTP(email: String, code: String, countryCode: String = "1", completion: @escaping (Result<Void, Error>) -> Void) {
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
    }

    func logout() {
        ThingSmartUser.sharedInstance()?.loginOut({
        }) { error in
        }
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
