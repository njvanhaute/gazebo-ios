//
//  GazeboAPIError.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/10/24.
//

import Foundation

enum GazeboAPIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case emailAlreadyInUse
}
