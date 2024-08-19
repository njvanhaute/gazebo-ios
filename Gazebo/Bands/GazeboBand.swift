//
//  GazeboBand.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/11/24.
//

import Foundation

struct GazeboBand: Identifiable, Hashable, Decodable {
    let id: Int
    let ownerId: Int
    let createdAt: String
    let version: Int
    let name: String
}

struct GazeboBandCreatedResponse: Decodable {
    let band: GazeboBand
}

struct GazeboBandList: Decodable {
    let bands: [GazeboBand]
}
