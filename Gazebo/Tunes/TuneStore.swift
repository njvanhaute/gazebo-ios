//
//  TuneStore.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/11/24.
//

import Foundation

class TuneStore: ObservableObject {
    let apiAgent = GazeboAPIAgent()
    let band: GazeboBand
    @Published var tuneList: GazeboTuneList?

    init(for band: GazeboBand) {
        self.band = band
    }

    func loadTunes() async throws {
        tuneList = try await apiAgent.getResource(from: "bands/\(band.id)/tunes")
    }
}
