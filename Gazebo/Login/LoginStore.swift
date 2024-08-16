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

        try saveSecretsToKeychain(email: form.email, password: form.password,
                                  accessToken: authTokenWrapped.authenticationToken.token)
        saveTokenExpiryToUserDefaults(tokenExpiry: authTokenWrapped.authenticationToken.expiry)
    }

    func keychainDataAlreadyExists(for account: String) -> Bool {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: apiAgent.hostname,
                                    kSecAttrAccount as String: account,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]

        var item: CFTypeRef?
        return SecItemCopyMatching(query as CFDictionary, &item) != errSecItemNotFound
    }

    func updateKeychainData(for account: String, password: String) throws {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: apiAgent.hostname,
                                    kSecAttrAccount as String: account]
        let passwordData = password.data(using: String.Encoding.utf8)!
        let attributes: [String: Any] = [kSecValueData as String: passwordData]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }

    func addDataToKeychain(for account: String, password: String) throws {
        let passwordData = password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: account,
                                    kSecAttrServer as String: apiAgent.hostname,
                                    kSecValueData as String: passwordData]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    func saveSecretsToKeychain(email: String, password: String, accessToken: String) throws {
        if keychainDataAlreadyExists(for: email) {
            try updateKeychainData(for: email, password: password)
        } else {
            try addDataToKeychain(for: email, password: password)
        }
    }

    func saveTokenExpiryToUserDefaults(tokenExpiry: String) {
        UserDefaults.standard.set(tokenExpiry, forKey: "com.gazebosoftware.apiTokenExpiry")
    }
}
