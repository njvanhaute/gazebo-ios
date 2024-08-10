//
//  AccountRegistrationView.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/9/24.
//

import SwiftUI

struct AccountRegistrationView: View {
    @ObservedObject var store: AccountRegistrationStore

    var body: some View {
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
            store.submit()
        } label: {
            Text("Register")
                .padding()
        }
        .disabled(store.disable)
    }
}

#Preview {
    @StateObject var store = AccountRegistrationStore()
    return AccountRegistrationView(store: store)
}
