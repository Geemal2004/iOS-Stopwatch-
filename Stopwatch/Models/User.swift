import Foundation

struct User: Codable {
    let id: String
    var nickname: String
    var email: String?
    var phone: String?
    var avatarUrl: String?
    let countryCode: String
    var timezoneId: String
}

struct AuthState {
    var isLoggedIn: Bool = false
    var isLoading: Bool = false
    var user: User?
    var error: String?
}

enum AuthMode {
    case login
    case register
}
