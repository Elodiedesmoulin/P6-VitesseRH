//
//  LogInView.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    LogoView()
                    Text("Login")
                        .font(.largeTitle)
                        .padding(.top, 20)
                    Spacer()
                    VStack(alignment: .leading, spacing: 15) {
                        Group {
                            Text("Email")
                                .font(.headline)
                            TextField("Email", text: $viewModel.email)
                                .autocorrectionDisabled(true)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            if !viewModel.email.isValidEmail() && !viewModel.email.isEmpty {
                                Text("Invalid email address")
                                    .foregroundColor(.red)
                                    .font(.footnote)
                            }
                        }
                        Group {
                            Text("Password")
                                .font(.headline)
                            SecureField("Password", text: $viewModel.password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            if !viewModel.password.isEmpty && viewModel.password.count < 6 {
                                Text("Password must be at least 6 characters")
                                    .foregroundColor(.red)
                                    .font(.footnote)
                            }
                        }
                    }
                    .padding(.horizontal)
                    Spacer()
                    Button(action: { viewModel.signIn() }) {
                        HStack {
                            Spacer()
                            Text("Sign in").padding()
                            Spacer()
                        }
                    }
                    .frame(maxWidth: geometry.size.width * 0.6)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.bottom, 10)
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                    NavigationLink(destination: RegisterView()) {
                        HStack {
                            Spacer()
                            Text("Register").padding()
                            Spacer()
                        }
                    }
                    .frame(maxWidth: geometry.size.width * 0.6)
                    .background(Color.gray)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    Spacer()
                }
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.gray]), startPoint: .bottom, endPoint: .top).ignoresSafeArea())
                .onTapGesture { UIApplication.shared.endEditing() }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


