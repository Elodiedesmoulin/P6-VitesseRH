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
    
    var body: some View {
        HStack {
            if isEditMode {
                Text(candidate.firstName + " " + candidate.lastName)
                    .font(.headline)
            } else {
                NavigationLink(destination: DetailView(candidate: $viewModel.candidates.first(where: { $0.id == candidate.id })!, token: token)) {
                    Text(candidate.firstName + " " + candidate.lastName)
                        .font(.headline)
                }
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}


