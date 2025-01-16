//
//  CandidateListView.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import SwiftUI

struct CandidateListView: View {
    @StateObject private var viewModel: CandidateListViewModel
    let token: String
    
    init(token: String) {
        self.token = token
        _viewModel = StateObject(wrappedValue: CandidateListViewModel(token: token))
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Button(action: {
                    viewModel.toggleEditMode()
                }) {
                    HStack {
                        Image(systemName: viewModel.isEditMode ? "arrow.uturn.backward.circle.fill" : "pencil.circle.fill")
                        Text(viewModel.isEditMode ? "Return" : "Edit")
                    }
                    .padding()
                    .background(Color(.black))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
                }
                
                TextField("Search by name or surname", text: $viewModel.searchText)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
                    .onChange(of: viewModel.searchText) { newValue in
                        viewModel.filterCandidates(by: newValue, showFavoritesOnly: viewModel.showFavoritesOnly)
                    }
                
                Button(action: {
                    viewModel.showFavoritesOnly.toggle()
                    viewModel.filterCandidates(by: viewModel.searchText, showFavoritesOnly: viewModel.showFavoritesOnly)
                }) {
                    Image(systemName: viewModel.showFavoritesOnly ? "star.fill" : "star")
                        .foregroundColor(viewModel.showFavoritesOnly ? .yellow : .gray)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            List(viewModel.filteredCandidates) { candidate in
                HStack {
                    if viewModel.isEditMode {
                        Button(action: {
                            viewModel.toggleSelection(for: candidate)
                        }) {
                            Image(systemName: viewModel.selectedCandidates.contains(candidate) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(.black)
                        }
                    }
                    
                    CandidateRowView(viewModel: viewModel, candidate: candidate, token: token, isEditMode: viewModel.isEditMode)
                    
                    Spacer()
                    
                    Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                        .foregroundColor(candidate.isFavorite ? .yellow : .gray)
                }
                .padding(.vertical, 5)
            }
            .navigationTitle("Candidates")
            .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "An unknown error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            if !viewModel.isEditMode {
                NavigationLink(destination: CreateCandidateView(viewModel: CreateCandidateViewModel(token: token), token: token)) {
                    Text("Create New Candidate")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.black))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.fetchCandidates()
        }
    }
}
