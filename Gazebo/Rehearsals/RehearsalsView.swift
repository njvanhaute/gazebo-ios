//
//  RehearsalsView.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/19/24.
//

import SwiftUI

struct RehearsalsView: View {
    let band: GazeboBand

    init(for band: GazeboBand) {
        self.band = band
    }

    var body: some View {
        VStack {
            Text("Rehearsals for \(band.name)")
        }
    }
}

#Preview {
    RehearsalsView(for: TestBand.SAQ)
}
