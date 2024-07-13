//
//  LoginView.swift
//  SwiftLink
//
//  Created by SIRSHAK DOLAI on 11/07/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loginError: String?
    @State private var isLoggedIn = false

    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if let loginError = loginError {
                    Text(loginError)
                        .foregroundColor(.red)
                        .padding()
                }

                Button(action: {
                    Task {
                        do {
                            try await NetworkManager.shared.login(email: email, password: password)
                            isLoggedIn = true
                        } catch {
                            loginError = "Login failed. Please check your credentials."
                        }
                    }
                }) {
                    Text("Login")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                NavigationLink(destination: ContentView(), isActive: $isLoggedIn) {
                    EmptyView()
                }
            }
            .navigationTitle("Login")
        }
    }
}
