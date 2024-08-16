//
//  LoginStore.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/11/24.
//

import Foundation
import Security

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

class LoginStore: ObservableObject {
    @Published var form = LoginForm(email: "", password: "")
    @Published var networkRequestIsInFlight = false

    var canSubmitForm: Bool {
        fieldsAreValid && !networkRequestIsInFlight
    }

    var fieldsAreValid: Bool {
        PasswordValidator.validate(form.password) && EmailValidator.validate(form.email)
    }

    func clearFormData() {
        form.email = ""
        form.password = ""
    }

    @MainActor
    func submit() async throws {
        networkRequestIsInFlight = true
        defer {
            networkRequestIsInFlight = false
        }

        let authTokenWrapped: AuthenticationTokenService =
        try await GazeboAPIAgent.shared.postResource(form, to: "tokens/authentication")

        GazeboAuthentication.shared.setSecrets(email: form.email,
                                                   password: form.password,
                                                   accessToken: authTokenWrapped.authenticationToken)
    }
}
