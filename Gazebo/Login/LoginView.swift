//
//  LoginView.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/9/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var store: LoginStore
    @State private var loginSuccess = false

    var body: some View {
        VStack {
            Spacer()
            Text("Log in to your account")
            textFields
            loginButton
            Spacer()
        }
    }

    var textFields: some View {
        VStack(alignment: .leading, spacing: 15) {
            TextField("Email address", text: $store.form.email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            SecureField("Password", text: $store.form.password)
        }
        .padding(20)
    }

    var loginButton: some View {
        Button {
            submitForm()
        } label: {
            Text("Login")
                .padding()
        }
        .disabled(!store.canSubmitForm)
    }

    func submitForm() {
        Task {
            do {
                try await store.submit()
                loginSuccess = true
            } catch GazeboAPIError.invalidURL {
                print("invalid URL")
            } catch GazeboAPIError.invalidResponse {
                print("invalid response")
            } catch GazeboAPIError.invalidData {
                print("invalid data")
            } catch GazeboAPIError.emailAlreadyInUse {
                print("duplicate email")
            } catch {
                print("unexpected error")
            }
        }
    }
}

#Preview {
    @StateObject var store = LoginStore()
    return LoginView(store: store)
}
