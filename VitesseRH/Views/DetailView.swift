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
    var token: String
    
    init(candidate: Binding<Candidate>, token: String) {
        _candidate = candidate
        _viewModel = StateObject(wrappedValue: DetailViewModel(service: VitesseRHService(), token: token, candidateId: candidate.id))
        self.token = token
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if let candidate = viewModel.candidate {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("First Name: \(candidate.firstName)")
                            .font(.headline)
                        Text("Last Name: \(candidate.lastName)")
                            .font(.headline)
                        Text("Email: \(candidate.email)")
                            .font(.headline)
                        Text("Phone: \(candidate.phone)")
                            .font(.headline)
                        if let linkedin = candidate.linkedinURL {
                            Text("LinkedIn: \(linkedin)")
                                .font(.headline)
                        }
                        if let note = candidate.note {
                            Text("Note: \(note)")
                                .font(.headline)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
                    
                    Button("Edit") {
                        isEditing = true
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
                    .sheet(isPresented: $isEditing, onDismiss: {
                        self.viewModel.fetchCandidateDetails()
                    }) {
                        EditingView(candidate: $candidate, viewModel: EditingViewModel(candidate: candidate, token: viewModel.token, candidateId: candidate.id, service: viewModel.service), isEditing: $isEditing)
                    }
                } else {
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
            }
            .padding()
            .background(Color("BackgroundGray"))
            .navigationTitle("Candidate Details")
        }
    }
}
