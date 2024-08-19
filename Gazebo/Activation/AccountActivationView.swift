//
//  AccountActivationView.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/19/24.
//

import SwiftUI

struct AccountActivationView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var store: ActivationStore
    @State private var cantFindBackend = false
    @State private var invalidToken = false
    @State private var accountActivated = false

    var body: some View {
        activationFormView
            .alert(
                "Invalid token",
                isPresented: $invalidToken,
                presenting:
                    """
                    The activation token you entered is invalid.
                    Please copy the token directly from the email you received
                    and try again.
                    """,
                actions: { _ in
                    Button("OK", role: .cancel) {
                        store.clearFormData()
                    }
                },
                message: { reason in Text(reason) }
            )
            .alert(
                "Can't connect to server",
                isPresented: $cantFindBackend,
                presenting:
                    """
                    We're unable to connect to our servers right now.
                    Please check your internet connection, or try again later.
                    """,
                actions: { _ in
                    Button("OK", role: .cancel) {
                        dismiss()
                    }
                },
                message: { reason in Text(reason) }
            )
            .alert(
                "Account activated!",
                isPresented: $accountActivated,
                presenting:
                    """
                    Your account was successfully activated! You can now log in.
                    """,
                actions: { _ in
                    Button("OK", role: .cancel) {
                        dismiss()
                    }
                },
                message: { reason in Text(reason) }
            )
    }

    var activationFormView: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("Activate your account")
            tokenField
            activateButton
            Spacer()
        }
    }

    var tokenField: some View {
        TextField("Activation Token", text: $store.form.token)
            .multilineTextAlignment(.center)
            .autocorrectionDisabled()
            .padding(20)
    }

    var activateButton: some View {
        Button {
            submitForm()
        } label: {
            Text("Activate")
                .padding()
        }
        .disabled(!store.canSubmitForm)
    }

    func submitForm() {
        Task {
            do {
                try await store.submit()
                accountActivated = true
            } catch GazeboAPIError.unprocessableEntity {
                invalidToken = true
            } catch {
                print(error)
                if let error = error as? URLError, error.code == .cannotConnectToHost {
                    cantFindBackend = true
                }
            }
        }
    }
}

#Preview {
    AccountActivationView(store: ActivationStore())
}
