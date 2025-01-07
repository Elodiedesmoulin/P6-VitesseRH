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
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(candidate.firstName) \(candidate.lastName)")
                    .font(.headline)
            }
            
            Spacer()
            
            NavigationLink(destination: DetailView(candidate: $viewModel.candidates.first(where: { $0.id == candidate.id })!, token: token)) {
                EmptyView()
            }
        }
        .padding(.vertical, 8)
    }
}
