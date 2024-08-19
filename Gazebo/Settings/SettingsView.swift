//
//  SettingsView.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/19/24.
//

import SwiftUI

struct SettingsView: View {
    let band: GazeboBand

    init(for band: GazeboBand) {
        self.band = band
    }

    var body: some View {
        VStack {
            Text("Settings for \(band.name)")
            Button("Log out") {
                GazeboAuthentication.shared.logout()
            }
        }
    }
}

#Preview {
    SettingsView(for: TestBand.SAQ)
}
