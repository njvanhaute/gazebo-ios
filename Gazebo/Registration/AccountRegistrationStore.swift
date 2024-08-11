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
    
    static let emailRegex = try? Regex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    
    var canSubmitForm: Bool {
        fieldsAreValid && !networkRequestIsInFlight
    }
    
    var fieldsAreValid: Bool {
        nameValid() && passwordValid() && emailValid()
    }
    
    func nameValid() -> Bool {
        form.name != ""
    }
    
    func emailValid() -> Bool {
        form.email != "" && form.email.firstMatch(of: AccountRegistrationStore.emailRegex!) != nil
    }
    
    func passwordValid() -> Bool {
        (8...72).contains(form.password.count)
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
            print(response.statusCode)
            throw GazeboAPIError.emailAlreadyInUse
        }
    }
}
