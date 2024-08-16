//
//  RootView.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/11/24.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var auth: GazeboAuthentication

    var body: some View {
        if auth.loggedIn {
            BandListView()
        } else {
            LandingPageView()
        }
    }
}

#Preview {
    RootView()
}
