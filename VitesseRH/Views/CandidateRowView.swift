//
//  CandidateRowView.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import SwiftUI

struct CandidateRowView: View {
    @ObservedObject var viewModel: CandidateListViewModel
    var candidate: Candidate
    var token: String
    var isEditMode: Bool
    @State private var isNavigationActive = false
    
    var body: some View {
        HStack {
            if isEditMode {
                Text(candidate.firstName + " " + candidate.lastName)
                    .font(.headline)
            } else {
                Button(action: {
                    isNavigationActive = true
                }) {
                    Text(candidate.firstName + " " + candidate.lastName)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                .background(
                    NavigationLink(
                        destination: DetailView(candidate: $viewModel.candidates.first(where: { $0.id == candidate.id })!, token: token, isAdmin: true),
                        isActive: $isNavigationActive
                    ) { EmptyView() }
                )
                .buttonStyle(PlainButtonStyle())
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "An unknown error occurred."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}


