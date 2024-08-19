//
//  BandListView.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/11/24.
//

import SwiftUI

struct BandListView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var bandStore: BandStore = BandStore()
    @State private var accountInactive = false

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
                do {
                    try await bandStore.loadBands()
                } catch GazeboAPIError.accountNotActivated {
                    accountInactive = true
                }
            }
        }
        .alert(
            "Account not activated",
            isPresented: $accountInactive,
            presenting:
                """
                Your account must be activated to use the app. Check your email for further instructions.
                """,
            actions: { _ in
                Button("OK", role: .cancel) {
                    GazeboAuthentication.shared.logout()
                }
            },
            message: { reason in Text(reason) })
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
