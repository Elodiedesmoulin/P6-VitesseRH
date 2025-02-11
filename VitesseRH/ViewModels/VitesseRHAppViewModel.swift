//
//  VitesseRHAppViewModel.swift
//  VitesseRH
//
//  Created by Elo on 30/01/2025.
//

import Foundation

final class VitesseRHAppViewModel: ObservableObject {
    @Published private(set) var isLogged: Bool = AuthenticationManager.shared.getToken() != nil
    
    var loginVM: LoginViewModel {
        LoginViewModel {
            Task { @MainActor in
                self.isLogged = true
            }
        }
    }
    
    var candidatesVM: CandidateListViewModel {
        CandidateListViewModel(onSignOut: {
            AuthenticationManager.shared.deleteAuthData()
            Task { @MainActor in
                self.isLogged = false
            }
        })
    }
}
