//
//  VitesseRHAppViewModel.swift
//  VitesseRH
//
//  Created by Elo on 30/01/2025.
//

import Foundation

final class VitesseRHAppViewModel: ObservableObject {
    @Published internal(set) var isLoggedIn = AuthenticationManager.shared.getToken() != nil
    
    var loginViewModel: LoginViewModel {
        LoginViewModel(authService: VitesseRHService(), onLoginSuccess: {
            Task { @MainActor in
                self.isLoggedIn = true
            }
        })
    }
    
    var candidateListViewModel: CandidateListViewModel {
        CandidateListViewModel(onSignOut: {
            AuthenticationManager.shared.deleteAuthData()
            Task { @MainActor in
                self.isLoggedIn = false
            }
        })
    }
}
