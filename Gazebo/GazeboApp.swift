//
//  GazeboApp.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/8/24.
//

import SwiftUI

@main
struct GazeboApp: App {
    @StateObject var accountRegistrationStore = AccountRegistrationStore()
    var body: some Scene {
        WindowGroup {
            AccountRegistrationView(store: accountRegistrationStore)
        }
    }
}
