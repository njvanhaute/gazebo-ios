//
//  RepertoireView.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/19/24.
//

import SwiftUI

struct RepertoireView: View {
    let band: GazeboBand

    init(for band: GazeboBand) {
        self.band = band
    }

    var body: some View {
        VStack {
            Text("Repertoire for \(band.name)")
        }
    }
}

#Preview {
    RepertoireView(for: TestBand.SAQ)
}
