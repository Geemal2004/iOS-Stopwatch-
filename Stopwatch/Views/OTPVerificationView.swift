import SwiftUI

struct OTPVerificationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

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
                    Text("Verify Email")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    Text("Enter the verification code sent to\n\(authViewModel.email)")
                        .font(.system(size: 16))
                        .foregroundColor(AppTheme.textSecondary)
                        .lineSpacing(4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 16) {
                    TextField("Enter OTP Code", text: $authViewModel.otpCode)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(AppTheme.surface)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 24, weight: .bold))
                        .focused($isFocused)
                        .onChange(of: authViewModel.otpCode) { newValue in
                            if newValue.count > 6 {
                                authViewModel.otpCode = String(newValue.prefix(6))
                            }
                        }

                    if let error = authViewModel.authState.error {
                        Text(error)
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Button {
                        authViewModel.verifyOTP()
                    } label: {
                        if authViewModel.authState.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Verify")
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(!authViewModel.isOTPFormValid || authViewModel.authState.isLoading)

                    Button("Resend Code") {
                        authViewModel.sendOTP()
                    }
                    .foregroundColor(AppTheme.primaryLight)
                    .font(.system(size: 15))
                    .disabled(authViewModel.authState.isLoading)
                }

                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .onAppear {
            isFocused = true
        }
        .interactiveDismissDisabled()
    }
}
