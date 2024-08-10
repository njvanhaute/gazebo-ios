//
//  AccountRegistrationStore.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/9/24.
//

import Foundation

class AccountRegistrationStore: ObservableObject {
    @Published var form = AccountRegistrationForm(name: "", email: "", password: "")
    static let emailRegex = try? Regex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    
    var disable: Bool {
        !nameValid() || !passwordValid() || !emailValid()
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
    
    func submit() {
        print("name = \(form.name), email = \(form.email), password = \(form.password)")
    }
}
