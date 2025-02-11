//
//  RegisterView.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()

    var body: some View {
        ScrollView {
            TextField("First Name", text: $viewModel.firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Last Name", text: $viewModel.lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)

            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)

            SecureField("Confirm Password", text: $viewModel.confirmPwd)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)

            Button(action: {
                viewModel.register()
            }) {
                HStack {
                    Spacer()
                    Text("Register")
                        .padding()
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage.errorDescription ?? "Error")
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }
        }
        .padding()
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .alert("Welcome " + viewModel.firstName, isPresented: $viewModel.isRegistered) {
            Button("Ok", role: .cancel) {
            }
        } message: {
            Text("Log in with your email and password.")
        }
    }
}
