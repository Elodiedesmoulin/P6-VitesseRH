//
//  DetailView.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel: DetailViewModel
    @State private var isEditing = false

    @Binding var candidate: Candidate

    init(candidate: Binding<Candidate>, token: String) {
        _candidate = candidate
        _viewModel = StateObject(wrappedValue: DetailViewModel(service: VitesseRHService(), token: token, candidateId: candidate.id))    }

    var body: some View {
        VStack {
            if let candidate = viewModel.candidate {
                Text("First Name: \(candidate.firstName)")
                Text("Last Name: \(candidate.lastName)")
                Text("Email: \(candidate.email)")
                Text("Phone: \(candidate.phone)")
                if let linkedin = candidate.linkedinURL {
                    Text("LinkedIn: \(linkedin)")
                }
                if let note = candidate.note {
                    Text("Note: \(note)")
                }

                
                Button("Edit") {
                    isEditing = true
                }
                .padding()
                .background(
                    NavigationLink(destination: EditingView(candidate: $candidate, viewModel: EditingViewModel(candidate: candidate, token: viewModel.token, candidateId: candidate.id, service: viewModel.service))) {
                        EmptyView()
                    }.hidden()
                )
            } else {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                ProgressView()
            }
        }
        .navigationTitle("Candidate Details")
        .padding()
    }
}






