//
//  LogInViewModel.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email = "elodie.dsmln@icloud.com"
    @Published var password = "Feu2stjean."
    @Published var token: String?
    @Published var isAuthenticated = false
    @Published var loginMessage: String?
    
    private let service = VitesseRHService()
    
    func login() {
        guard isEmailValid(email) else {
            loginMessage = VitesseRHError.invalidParameters.localizedDescription
            return
        }
        
        guard isPasswordValid(password) else {
            loginMessage = VitesseRHError.invalidParameters.localizedDescription
            return
        }
        
        Task {
            do {
                let (receivedToken, _) = try await service.login(email: email, password: password)
                token = receivedToken
                isAuthenticated = true
                loginMessage = nil
            } catch let error as VitesseRHError {
                isAuthenticated = false
                loginMessage = error.localizedDescription
            } catch let error as URLError {
                if error.code == .notConnectedToInternet {
                    loginMessage = VitesseRHError.networkError.localizedDescription
                } else if error.code == .timedOut {
                    loginMessage = VitesseRHError.timeout.localizedDescription
                } else {
                    loginMessage = VitesseRHError.unknown.localizedDescription
                }
            } catch {
                isAuthenticated = false
                loginMessage = VitesseRHError.unknown.localizedDescription
            }
        }
    }
    
    func logout() {
        isAuthenticated = false
        token = nil
        email = ""
        password = ""
        loginMessage = nil
    }
    
    private func isEmailValid(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func isPasswordValid(_ password: String) -> Bool {
        return password.count >= 6
    }
}


