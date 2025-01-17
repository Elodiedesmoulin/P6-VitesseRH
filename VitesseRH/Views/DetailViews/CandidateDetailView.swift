//
//  DetailView.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import SwiftUI

struct CandidateDetailView: View {
    @StateObject private var viewModel: DetailViewModel
    @Binding var candidate: Candidate
    @State private var isEditing = false
    var token: String
    var isAdmin: Bool
    
    init(candidate: Binding<Candidate>, token: String, isAdmin: Bool) {
        _candidate = candidate
        _viewModel = StateObject(wrappedValue: DetailViewModel(service: VitesseRHService(), token: token, candidateId: candidate.wrappedValue.id, isAdmin: isAdmin))
        self.token = token
        self.isAdmin = isAdmin
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(spacing: 15) {
                    
                    CandidateDetailHeader(candidate: $candidate, toggleFavorite: {
                        viewModel.toggleFavorite()
                    }, isAdmin: isAdmin)
                    
                    CandidateDetailInfo(candidate: candidate)
                    NoteView(candidate: candidate)
                    
                    Button(action: {
                        isEditing = true
                    }) {
                        Text("Edit")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
                    }
                    .sheet(isPresented: $isEditing, onDismiss: {
                        viewModel.fetchCandidateDetails()
                    }) {
                        EditingView(candidate: $candidate, viewModel: EditingViewModel(candidate: candidate, token: viewModel.token, candidateId: candidate.id, service: viewModel.service), isEditing: $isEditing)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.gray.opacity(0.1), radius: 10, x: 0, y: 5)
            }
            .padding()
            .navigationTitle("Candidate Details")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "An unknown error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview(body: {
    CandidateDetailView(candidate: .constant(Candidate(id: "dfghj", firstName: "Elo", lastName: "Desm", email: "elo.desl@icloud.com", phone: "0660123626", isFavorite: true)) , token: "fghjkl", isAdmin: true)
})
