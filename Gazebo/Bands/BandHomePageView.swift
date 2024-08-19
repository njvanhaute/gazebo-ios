//
//  BandHomePageView.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/19/24.
//

import SwiftUI

struct BandHomePageView: View {
    let band: GazeboBand

    init(for band: GazeboBand) {
        self.band = band
    }

    var body: some View {
        TabView {
            RepertoireView(for: band)
                .tabItem {
                    Label("Repertoire", systemImage: "music.note.list")
                }
            RehearsalsView(for: band)
                .tabItem {
                    Label("Rehearsals", systemImage: "music.note.house")
                }
            SettingsView(for: band)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    BandHomePageView(for: GazeboBand(id: 1, ownerId: 1, createdAt: "", version: 1, name: "Shauncey Ali Quartet"))
}
