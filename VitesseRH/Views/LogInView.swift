//
//  LogInView.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)

                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)

                
                Button("Login") {
                    viewModel.login()
                }
                .padding()
                
                if let loginMessage = viewModel.loginMessage {
                    Text(loginMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                if viewModel.isAuthenticated {
                    NavigationLink(destination: CandidateListView(token: viewModel.token ?? ""), isActive: $viewModel.isAuthenticated) {
                        EmptyView()
                    }
                }
                
                NavigationLink(destination: RegisterView()) {
                    Text("Don't have an account? Register here.")
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .padding()
            .navigationTitle("Login")
        }
    }
}
