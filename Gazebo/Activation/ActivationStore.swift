//
//  ActivationStore.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/19/24.
//

import Foundation

class ActivationStore: ObservableObject {
    @Published var form = ActivationForm(token: "")
    @Published var networkRequestIsInFlight = false

    var canSubmitForm: Bool {
        fieldsAreValid && !networkRequestIsInFlight
    }

    var fieldsAreValid: Bool {
        form.token.count == 26
    }

    func clearFormData() {
        form.token = ""
    }

    @MainActor
    func submit() async throws {
        networkRequestIsInFlight = true
        defer {
            networkRequestIsInFlight = false
        }

        form.token = form.token.uppercased()
        let _: ActivationResponse = try await GazeboAPIAgent.shared.putResource(form, to: "users/activated")
    }
}
