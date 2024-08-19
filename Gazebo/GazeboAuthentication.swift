//
//  GazeboAuthentication.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/11/24.
//

import Foundation
import KeychainSwift

class GazeboAuthentication: ObservableObject {
    enum KeychainDataType: String {
        case token
        case password
    }

    static let shared = GazeboAuthentication()
    let keychain = KeychainSwift()

    @Published var loggedIn = false

    private init() {
        loggedIn = hasValidCredentials()
    }

    private let userDefaultsEmailKey = "com.gazebosoftware.email"
    private let userDefaultsTokenExpiryKey = "com.gazebosoftware.apiTokenExpiry"

    private func keychainKey(for account: String, type: KeychainDataType) -> String {
        return "com.gazebosoftware.\(account).\(type.rawValue)"
    }

    func hasValidCredentials() -> Bool {
        if let email = getEmail() {
            let password = getPassword(for: email)
            let token = getToken(for: email)
            if expiryValid() && password != nil && token != nil {
                return true
            }
        }
        return false
    }

    func tokenTTL() -> TimeInterval {
        if let expiryDate = getExpiryDate() {
            return expiryDate - Date.now
        }
        return TimeInterval(0)
    }

    func setSecrets(email: String, password: String, accessToken: AuthenticationToken) {
        keychain.set(password, forKey: keychainKey(for: email, type: .password))
        keychain.set(accessToken.token, forKey: keychainKey(for: email, type: .token))

        UserDefaults.standard.set(email, forKey: userDefaultsEmailKey)
        UserDefaults.standard.set(accessToken.expiry, forKey: userDefaultsTokenExpiryKey)

        loggedIn = true
    }

    func reauthenticateWithStoredCredentials() async throws {
        let email = getEmail()!
        let password = getPassword(for: email)!
        let form = LoginForm(email: email, password: password)
        let authTokenWrapped: AuthenticationTokenService =
            try await GazeboAPIAgent.shared.postResource(form, to: "tokens/authentication", authenticate: false)

        GazeboAuthentication.shared.setSecrets(email: form.email,
                                               password: form.password,
                                               accessToken: authTokenWrapped.authenticationToken)
    }

    func logout() {
        if let email = getEmail() {
            keychain.delete(keychainKey(for: email, type: .password))
            keychain.delete(keychainKey(for: email, type: .token))
            UserDefaults.standard.removeObject(forKey: userDefaultsEmailKey)
            UserDefaults.standard.removeObject(forKey: userDefaultsTokenExpiryKey)
        }

        loggedIn = false
    }

    func getEmail() -> String? {
        UserDefaults.standard.string(forKey: userDefaultsEmailKey)
    }

    func getPassword(for email: String) -> String? {
        keychain.get(keychainKey(for: email, type: .password))
    }

    func getToken(for email: String) -> String? {
        keychain.get(keychainKey(for: email, type: .token))
    }

    func getExpiryDate() -> Date? {
        if let expiryString = UserDefaults.standard.string(forKey: userDefaultsTokenExpiryKey) {
            return DateFormatter.shared.formatter.date(from: expiryString)
        }
        return nil
    }

    private func expiryValid() -> Bool {
        if let expiryDate = getExpiryDate() {
            return Date.now < expiryDate
        }
        return false
    }
}
