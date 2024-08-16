//
//  BandStore.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/16/24.
//

import Foundation

class BandStore: ObservableObject {
    let userId: String
    @Published var bandList: GazeboBandList?

    init() {
        let email = GazeboAuthentication.shared.getEmail()!
        self.userId = GazeboAuthentication.shared.getUserId(for: email)!
    }

    @MainActor
    func loadBands() async throws {
        print(userId)
        do {
            bandList = try await GazeboAPIAgent.shared.getResource(from: "users/\(userId)/bands", authenticate: true)
        } catch {
            print(error)
        }
    }
}
