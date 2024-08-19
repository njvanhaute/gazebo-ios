//
//  BandStore.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/16/24.
//

import Foundation

class BandStore: ObservableObject {
    @Published var bandList: GazeboBandList?

    @MainActor
    func loadBands() async throws {
        bandList = try await GazeboAPIAgent.shared.getResource(from: "my/bands", authenticate: true)
    }
}
