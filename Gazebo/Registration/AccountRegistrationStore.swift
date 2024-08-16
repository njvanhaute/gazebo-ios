//
//  AccountRegistrationStore.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/9/24.
//

import Foundation

class AccountRegistrationStore: ObservableObject {
    @Published var form = AccountRegistrationForm(name: "", email: "", password: "")
    @Published var networkRequestIsInFlight = false

    var canSubmitForm: Bool {
        fieldsAreValid && !networkRequestIsInFlight
    }

    var fieldsAreValid: Bool {
        form.name != "" && PasswordValidator.validate(form.password) && EmailValidator.validate(form.email)
    }

    func clearFormData() {
        form.name = ""
        form.email = ""
        form.password = ""
    }

    @MainActor
    func submit() async throws {
        networkRequestIsInFlight = true
        defer {
            networkRequestIsInFlight = false
        }

        let endpoint = "http://localhost:4000/v1/users"

        guard let url = URL(string: endpoint) else {
            throw GazeboAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        guard let encoded = try? JSONEncoder().encode(form) else {
            throw GazeboAPIError.invalidData
        }

        let (_, response) = try await URLSession.shared.upload(for: request, from: encoded)

        guard let response = response as? HTTPURLResponse else {
            throw GazeboAPIError.invalidResponse
        }

        if response.statusCode != 202 {
            throw GazeboAPIError.emailAlreadyInUse
        }
    }
}
