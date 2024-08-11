//
//  GazeboTune.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/9/24.
//

import Foundation

struct GazeboTuneService: Decodable {
    let tune: GazeboTune
}

struct GazeboTune: Identifiable, Codable {
    let id: Int
    let createdAt: String
    let version: Int
    let title: String
    let keys: [String]
    let timeSignatureUpper: Int
    let timeSignatureLower: Int
    let bandId: Int
    let status: String
}
