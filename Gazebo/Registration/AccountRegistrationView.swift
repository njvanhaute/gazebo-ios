//
//  AccountRegistrationView.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/9/24.
//

import SwiftUI

struct AccountRegistrationView: View {
    @ObservedObject var store: AccountRegistrationStore
    @State private var enteredDuplicateEmail = false
    @State private var accountCreated = false
    
    var body: some View {
        registrationFormView
            .alert(
                "Account already exists",
                isPresented: $enteredDuplicateEmail,
                presenting: "The email address \(store.form.email) is already in use by another account.",
                actions: { _ in
                    Button("OK", role: .cancel) {
                        store.form.email = ""
                    }
                },
                message: { reason in Text(reason) })
            .alert(
                "Account created!",
                isPresented: $accountCreated,
                presenting: "Your account was created successfully! Please check your email for account activation details.",
                actions: { _ in Button("OK", role: .cancel) {}},
                message: { reason in Text(reason) })
    }
    
    var registrationFormView: some View {
        VStack() {
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
            TextField("Email address", text: $store.form.email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .disableAutocorrection(true)
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
                print("unexpected error")
            }
        }
    }
}

#Preview {
    @StateObject var store = AccountRegistrationStore()
    return AccountRegistrationView(store: store)
}
