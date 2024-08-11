//
//  LandingPageView.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/11/24.
//

import SwiftUI

struct LandingPageView: View {
    @StateObject private var registrationStore = AccountRegistrationStore()
    @StateObject private var loginStore = LoginStore()
    var body: some View {
        NavigationStack {
            Text("Gazebo")
                .font(.largeTitle)
            HStack {
                registerButton
                loginButton
            }
        }
    }

    var registerButton: some View {
        NavigationLink("Register") {
            AccountRegistrationView(store: registrationStore)
        }
    }

    var loginButton: some View {
        NavigationLink("Login") {
            LoginView(store: loginStore)
        }
    }
}

#Preview {
    LandingPageView()
}
