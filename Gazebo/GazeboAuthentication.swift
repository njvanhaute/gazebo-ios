//
//  GazeboAuthentication.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/11/24.
//

import Foundation

class GazeboAuthentication: ObservableObject {
    var accessToken: String?

    static let shared = GazeboAuthentication()

    @Published var loggedIn = false
}
