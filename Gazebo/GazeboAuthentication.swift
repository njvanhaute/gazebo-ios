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
            let password = keychain.get(keychainKey(for: email, type: .password))
            let token = keychain.get(keychainKey(for: email, type: .token))
            if expiryValid() && password != nil && token != nil {
                return true
            }
        }
        return false
    }

    func cacheSecrets(email: String, password: String, accessToken: AuthenticationToken) {
        keychain.set(password, forKey: keychainKey(for: email, type: .password))
        keychain.set(accessToken.token, forKey: keychainKey(for: email, type: .token))

        UserDefaults.standard.set(email, forKey: userDefaultsEmailKey)
        UserDefaults.standard.set(accessToken.expiry, forKey: userDefaultsTokenExpiryKey)
    }

    private func getEmail() -> String? {
        UserDefaults.standard.string(forKey: userDefaultsEmailKey)
    }

    private func getDateFormatter() -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withFractionalSeconds,
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withColonSeparatorInTime,
            .withColonSeparatorInTimeZone
        ]
        return formatter
    }

    private func expiryValid() -> Bool {
        if let expiryString = UserDefaults.standard.string(forKey: userDefaultsTokenExpiryKey) {
            let formatter = getDateFormatter()
            if let expiryDate = formatter.date(from: expiryString) {
                if Date.now < expiryDate {
                    return true
                }
            }
        }
        return false
    }

}
