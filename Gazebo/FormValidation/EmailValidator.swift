//
//  EmailValidator.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/11/24.
//

import Foundation

struct EmailValidator {
    static let emailRegex = try? Regex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    static func validate(_ emailAddress: String) -> Bool {
        return emailAddress != "" && emailAddress.firstMatch(of: emailRegex!) != nil
    }
}
