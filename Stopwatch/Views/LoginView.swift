import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showPassword = false
    @FocusState private var focusedField: Field?

    enum Field {
        case email, password
    }

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Button {
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
                        Text("Welcome Back")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        Text("Sign in to your account")
                            .font(.system(size: 16))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 16) {
                        TextField("Email", text: $authViewModel.email)
                            .textFieldStyle(.plain)
                            .padding()
                            .background(AppTheme.surface)
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .focused($focusedField, equals: .email)

                        HStack {
                            if showPassword {
                                TextField("Password", text: $authViewModel.password)
                                    .textFieldStyle(.plain)
                            } else {
                                SecureField("Password", text: $authViewModel.password)
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
                    }

                    if let error = authViewModel.authState.error {
                        Text(error)
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Button {
                        authViewModel.login()
                    } label: {
                        if authViewModel.authState.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Sign In")
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(!authViewModel.isFormValid || authViewModel.authState.isLoading)

                    Spacer()
                }
                .padding(.horizontal, 24)
            }
        }
        .onTapGesture {
            focusedField = nil
        }
    }
}
