//
//  AuthenticationToken.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/11/24.
//

import Foundation

struct AuthenticationTokenService: Decodable {
    let authenticationToken: AuthenticationToken
}

struct AuthenticationToken: Decodable {
    let token: String
    let expiry: String
    let userId: Int
}
