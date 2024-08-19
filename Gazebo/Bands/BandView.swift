//
//  BandView.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/16/24.
//

import SwiftUI

struct BandView: View {
    let band: GazeboBand

    init(for band: GazeboBand) {
        self.band = band
    }

    var body: some View {
        HStack {
            Text(band.name)
            VStack {
                Text(DateFormatter.shared.formatter.date(from: band.createdAt)?.formatted() ?? "No date found")
                Text("ID #\(band.id)")
            }
            .font(.footnote)
        }
    }
}

#Preview {
    BandView(for: GazeboBand(id: 1, ownerId: 1, createdAt: "Now", version: 1, name: "Test Band"))
}
