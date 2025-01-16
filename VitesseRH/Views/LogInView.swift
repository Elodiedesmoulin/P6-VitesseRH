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
            GeometryReader { geometry in
                VStack {
                    LogoView()
                    
                    Text("Login")
                        .font(.largeTitle)
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Email")
                            .font(.headline)
                        TextField("", text: $viewModel.email)
                            .autocorrectionDisabled(true)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("Password")
                            .font(.headline)
                        SecureField("", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.login()
                    }) {
                        HStack {
                            Spacer()
                            Text("Sign in")
                                .padding()
                            Spacer()
                        }
                    }
                    .frame(maxWidth: geometry.size.width * 0.4)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
                    
                    if let loginMessage = viewModel.loginMessage {
                        Text(loginMessage)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                    
                    if viewModel.isAuthenticated {
                        NavigationLink(destination: CandidateListView(token: viewModel.token ?? ""), isActive: $viewModel.isAuthenticated) {
                            EmptyView()
                        }
                    }
                    
                    NavigationLink(destination: RegisterView()) {
                        HStack {
                            Spacer()
                            Text("Register")
                                .padding()
                            Spacer()
                        }
                    }
                    .frame(maxWidth: geometry.size.width * 0.4)
                    .background(Color.gray)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
                    .padding(.top, 10)
                    
                    Spacer()
                }
                .padding()
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.gray]), startPoint: .bottom, endPoint: .top)
                        .ignoresSafeArea()
                )
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .animation(.easeInOut, value: viewModel.isAuthenticated)
    }
}

extension UIApplication {
    func endEditing() {
        guard let windowScene = connectedScenes.first as? UIWindowScene else { return }
        windowScene.windows.first?.endEditing(true)
    }
}
