//
//  PasswordValidator.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/11/24.
//

import Foundation

struct PasswordValidator {
    static func validate(_ password: String) -> Bool {
        (8...72).contains(password.count)
    }
}
