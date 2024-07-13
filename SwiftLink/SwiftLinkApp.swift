//
//  SwiftLinkApp.swift
//  SwiftLink
//
//  Created by SIRSHAK DOLAI on 10/07/24.
//

import SwiftUI

@main
struct SwiftLinkApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if appState.currentView == .signup {
                SignUpView()
                    .environmentObject(appState)
            } else if appState.currentView == .login {
                LoginView()
                    .environmentObject(appState)
            } else {
                ContentView()
                    .environmentObject(appState)
            }
        }
    }
}

class AppState: ObservableObject {
    enum ViewState {
        case signup
        case login
        case home
    }

    @Published var currentView: ViewState = .signup
}
