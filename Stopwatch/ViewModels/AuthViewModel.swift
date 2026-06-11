import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var authState = AuthState()
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var countryCode = "1"
    @Published var otpCode = ""
    @Published var showOTP = false
    @Published var showLogin = false

    var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && password.count >= 6
    }

    var isRegisterFormValid: Bool {
        !email.isEmpty && !password.isEmpty && password == confirmPassword && password.count >= 6
    }

    var isOTPFormValid: Bool {
        otpCode.count >= 4
    }

    init() {
        checkLoginStatus()
    }

    func checkLoginStatus() {
        if let savedUser = UserDefaults.standard.getSavedUser() {
            authState.isLoggedIn = true
            authState.user = savedUser
        }
    }

    func login() {
        guard isFormValid else { return }
        authState.isLoading = true
        authState.error = nil

        AuthService.shared.login(email: email, password: password, countryCode: countryCode) { [weak self] result in
            DispatchQueue.main.async {
                self?.authState.isLoading = false
                switch result {
                case .success(let user):
                    self?.authState.isLoggedIn = true
                    self?.authState.user = user
                case .failure(let error):
                    self?.authState.error = error.localizedDescription
                }
            }
        }
    }

    func register() {
        guard isRegisterFormValid else { return }
        authState.isLoading = true
        authState.error = nil

        AuthService.shared.register(email: email, password: password, countryCode: countryCode) { [weak self] result in
            DispatchQueue.main.async {
                self?.authState.isLoading = false
                switch result {
                case .success:
                    self?.showOTP = true
                case .failure(let error):
                    self?.authState.error = error.localizedDescription
                }
            }
        }
    }

    func verifyOTP() {
        guard isOTPFormValid else { return }
        authState.isLoading = true
        authState.error = nil

        AuthService.shared.verifyOTP(email: email, code: otpCode, countryCode: countryCode) { [weak self] result in
            DispatchQueue.main.async {
                self?.authState.isLoading = false
                switch result {
                case .success:
                    self?.showOTP = false
                    self?.showLogin = true
                case .failure(let error):
                    self?.authState.error = error.localizedDescription
                }
            }
        }
    }

    func sendOTP() {
        authState.isLoading = true
        AuthService.shared.register(email: email, password: password, countryCode: countryCode) { [weak self] result in
            DispatchQueue.main.async {
                self?.authState.isLoading = false
                switch result {
                case .success:
                    self?.showOTP = true
                case .failure(let error):
                    self?.authState.error = error.localizedDescription
                }
            }
        }
    }

    func logout() {
        AuthService.shared.logout()
        authState = AuthState()
        email = ""
        password = ""
    }

    func clearError() {
        authState.error = nil
    }
}
