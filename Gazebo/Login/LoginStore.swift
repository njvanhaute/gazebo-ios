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
    let apiAgent = GazeboAPIAgent()

    var canSubmitForm: Bool {
        fieldsAreValid && !networkRequestIsInFlight
    }

    var fieldsAreValid: Bool {
        PasswordValidator.validate(form.password) && EmailValidator.validate(form.email)
    }

    @MainActor
    func submit() async throws {
        networkRequestIsInFlight = true
        defer {
            networkRequestIsInFlight = false
        }

        let authTokenWrapped: AuthenticationTokenService =
            try await apiAgent.postResource(form, to: "tokens/authentication")

        let account = form.email
        let password = form.password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: account,
                                    kSecValueData as String: password]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print(status)
            throw KeychainError.unhandledError(status: status)
        }
        print(authTokenWrapped.authenticationToken)
    }
}
