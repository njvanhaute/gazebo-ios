//
//  BandListView.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/11/24.
//

import SwiftUI

struct BandListView: View {
    @StateObject private var bandStore: BandStore = BandStore()

    var body: some View {
        NavigationStack {
            if bandStore.bandList == nil {
                ProgressView()
            } else {
                bandList
            }
        }
        .task {
            Task {
                try await bandStore.loadBands()
            }
        }
        Button("Log out") {
            GazeboAuthentication.shared.logout()
        }
    }

    var bandList: some View {
        List(bandStore.bandList!.bands) { band in
            NavigationLink(value: band) {
                BandView(for: band)
                    .padding()
            }
        }
        .navigationTitle("Your Bands")
        .navigationDestination(for: GazeboBand.self) { band in
            BandView(for: band)
        }
    }
}

#Preview {
    BandListView()
}
