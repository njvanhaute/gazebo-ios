//
//  AccountRegistrationView.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/9/24.
//

import SwiftUI

struct AccountRegistrationView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var store: AccountRegistrationStore
    @State private var enteredDuplicateEmail = false
    @State private var accountCreated = false
    @State private var cantFindBackend = false

    var body: some View {
        registrationFormView
            .alert(
                "Account already exists",
                isPresented: $enteredDuplicateEmail,
                presenting: "The email address \(store.form.email) is already in use by another account.",
                actions: { _ in
                    Button("OK", role: .cancel) {
                        store.form.email = ""
                        store.form.password = ""
                    }
                },
                message: { reason in Text(reason) })
            .alert(
                "Account created!",
                isPresented: $accountCreated,
                presenting:
                    """
                    Your account was created successfully! Please check your email for account activation details.
                    """,
                actions: { _ in
                    Button("OK", role: .cancel) {
                        dismiss()
                    }
                },
                message: { reason in Text(reason) })
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
    }

    var registrationFormView: some View {
        VStack {
            Spacer()
            Text("Create an account")
            textFields
            registerButton
            Spacer()
        }
    }

    var textFields: some View {
        VStack(alignment: .leading, spacing: 15) {
            TextField("Name", text: $store.form.name)
                .autocorrectionDisabled()
            TextField("Email address", text: $store.form.email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocorrectionDisabled()
                .autocapitalization(.none)
            SecureField("Password", text: $store.form.password)
        }
        .padding(20)
    }

    var registerButton: some View {
        Button {
            submitForm()
        } label: {
            Text("Register")
                .padding()
        }
        .disabled(!store.canSubmitForm)
    }

    func submitForm() {
        Task {
            do {
                try await store.submit()
                store.clearFormData()
                accountCreated = true
            } catch GazeboAPIError.invalidURL {
                print("invalid URL")
            } catch GazeboAPIError.invalidResponse {
                print("invalid response")
            } catch GazeboAPIError.invalidData {
                print("invalid data")
            } catch GazeboAPIError.emailAlreadyInUse {
                enteredDuplicateEmail = true
            } catch {
                if let error = error as? URLError, error.code == .cannotConnectToHost {
                    cantFindBackend = true
                }
            }
        }
    }
}

#Preview {
    @StateObject var store = AccountRegistrationStore()
    return AccountRegistrationView(store: store)
}
