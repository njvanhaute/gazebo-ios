//
//  GazeboTuneList.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/11/24.
//

import Foundation

struct GazeboPaginationMetadata: Decodable {
    let currentPage: Int
    let pageSize: Int
    let firstPage: Int
    let lastPage: Int
    let totalRecords: Int
}

struct GazeboTuneList: Decodable {
    let metadata: GazeboPaginationMetadata
    let tunes: [GazeboTune]
}
