import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @FocusState private var focusedField: Field?

    enum Field {
        case email, password, confirm
    }

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Button {
                            authViewModel.clearError()
                            dismiss()
                        } label: {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding(.top, 16)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Create Account")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        Text("Get started with your smart home")
                            .font(.system(size: 16))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 16) {
                        HStack {
                            Text("+" + authViewModel.countryCode)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 16)
                                .background(AppTheme.surface)
                                .cornerRadius(12)

                            TextField("Email", text: $authViewModel.email)
                                .textFieldStyle(.plain)
                                .padding()
                                .background(AppTheme.surface)
                                .cornerRadius(12)
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                .focused($focusedField, equals: .email)
                        }

                        HStack {
                            if showPassword {
                                TextField("Password", text: $authViewModel.password)
                                    .textFieldStyle(.plain)
                            } else {
                                SecureField("Password (min 6 characters)", text: $authViewModel.password)
                                    .textFieldStyle(.plain)
                            }
                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                        }
                        .padding()
                        .background(AppTheme.surface)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .focused($focusedField, equals: .password)

                        HStack {
                            if showConfirmPassword {
                                TextField("Confirm Password", text: $authViewModel.confirmPassword)
                                    .textFieldStyle(.plain)
                            } else {
                                SecureField("Confirm Password", text: $authViewModel.confirmPassword)
                                    .textFieldStyle(.plain)
                            }
                            Button {
                                showConfirmPassword.toggle()
                            } label: {
                                Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                        }
                        .padding()
                        .background(AppTheme.surface)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .focused($focusedField, equals: .confirm)
                    }

                    if let error = authViewModel.authState.error {
                        Text(error)
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Button {
                        authViewModel.register()
                    } label: {
                        if authViewModel.authState.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Create Account")
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(!authViewModel.isRegisterFormValid || authViewModel.authState.isLoading)

                    Spacer()
                }
                .padding(.horizontal, 24)
            }
        }
        .fullScreenCover(isPresented: $authViewModel.showOTP) {
            OTPVerificationView()
                .environmentObject(authViewModel)
        }
        .onTapGesture {
            focusedField = nil
        }
    }
}
