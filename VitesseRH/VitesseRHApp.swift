//
//  VitesseRHApp.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import SwiftUI

@main
struct VitesseRHApp: App {

    @StateObject var viewModel = VitesseRHAppViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if viewModel.isLogged {
                    CandidateListView()
                } else {
                    LoginView(viewModel: viewModel.loginVM)
                }
            }
        }
    }
}
