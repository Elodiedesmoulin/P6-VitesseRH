//
//  CandidateListView.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import SwiftUI

struct CandidateListView: View {
    @StateObject private var viewModel: CandidateListViewModel
    @State private var searchText: String = ""
    var token: String
    
    init(token: String) {
        self.token = token
        _viewModel = StateObject(wrappedValue: CandidateListViewModel(token: token))
    }
    
    var body: some View {
        VStack {
            TextField("Search by name or surname", text: $searchText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: searchText) { newValue in
                    viewModel.filterCandidates(by: newValue)
                }
            
            List(viewModel.filteredCandidates) { candidate in
                HStack {
                    CandidateRowView(viewModel: viewModel, candidate: candidate, token: token)
                    
                    Button(action: {
                        viewModel.toggleFavorite(for: candidate)
                    }) {
                        HStack {
                            Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                                .foregroundColor(candidate.isFavorite ? .yellow : .gray)
                        }
                        .padding()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Candidates")
            .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "An unknown error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            NavigationLink(destination: CreateCandidateView(viewModel: CreateCandidateViewModel(token: token), token: token)) {
                Text("Create New Candidate")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchCandidates()
        }
    }
}
