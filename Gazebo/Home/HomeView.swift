//
//  HomeView.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/11/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        Button("Log out") {
            GazeboAuthentication.shared.logout()
        }
    }
}

#Preview {
    HomeView()
}
