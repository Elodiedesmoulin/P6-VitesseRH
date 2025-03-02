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
        _viewModel = StateObject(wrappedValue: DetailViewModel(token: token, candidate: candidate.wrappedValue, isAdmin: isAdmin, service: VitesseRHService()))
        self.token = token
        self.isAdmin = isAdmin
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    CandidateDetailHeader(candidate: $candidate, toggleFavorite: {
                        viewModel.toggleFavorite()
                    }, isAdmin: isAdmin)
                    .padding(.bottom, 20)
                    
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
                        EditingView(
                            viewModel: EditingViewModel(
                                candidate: $candidate,
                                token: viewModel.token,
                                candidateId: candidate.id,
                                service: viewModel.service
                            ),
                            isEditing: $isEditing
                        )
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.gray.opacity(0.1), radius: 10, x: 0, y: 5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.top, 30)
                .padding(.horizontal, 16)
            }
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
