//
//  SignUpView.swift
//  SwiftLink
//
//  Created by SIRSHAK DOLAI on 11/07/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSigningUp = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .padding(.bottom, 20)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 20)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 20)

            Button(action: {
                isSigningUp = true
                Task {
                    do {
                        let response = try await NetworkManager.shared.signUp(email: email, password: password)
                        if response.success {
                            DispatchQueue.main.async {
                                isSigningUp = false
                                appState.currentView = .login
                            }
                        }
                    } catch {
                        alertMessage = error.localizedDescription
                        showAlert = true
                        isSigningUp = false
                    }
                }
            }) {
                Text("Sign Up")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .padding(.top, 20)

            Spacer()
        }
        .padding()
        .disabled(isSigningUp)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView().environmentObject(AppState())
    }
}
