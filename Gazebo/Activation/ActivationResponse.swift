//
//  ActivationResponse.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/19/24.
//

import Foundation

struct ActivationResponse: Decodable {
    let user: ActivatedUser
}

struct ActivatedUser: Decodable {
    let id: Int
    let createdAt: String
    let name: String
    let email: String
    let activated: Bool
}
