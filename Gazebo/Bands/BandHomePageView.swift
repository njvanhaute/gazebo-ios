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
        VStack {
            header
            repertoireLink
            rehearsalsLink
            settingsLink
        }
    }

    var repertoireLink: some View {
        NavigationLink {
            RepertoireView(for: band)
                .navigationDestination(for: GazeboTune.self) { tune in
                    Text(tune.title)
                }
        } label: {
            Label("Repertoire", systemImage: "music.note.list")
        }
        .font(.title)
        .padding(5)
    }

    var rehearsalsLink: some View {
        NavigationLink {
            RehearsalsView(for: band)
        } label: {
            Label("Rehearsals", systemImage: "music.note.house")
        }
        .font(.title)
        .padding(5)
    }

    var settingsLink: some View {
        NavigationLink {
            SettingsView(for: band)
        } label: {
            Label("Settings", systemImage: "gearshape")
        }
        .font(.title)
        .padding(5)
    }

    var header: some View {
        Text(band.name)
            .bold()
            .font(.largeTitle)
            .padding(20)
    }
}

#Preview {
    BandHomePageView(for: GazeboBand(id: 1, ownerId: 1, createdAt: "", version: 1, name: "Shauncey Ali Quartet"))
}
