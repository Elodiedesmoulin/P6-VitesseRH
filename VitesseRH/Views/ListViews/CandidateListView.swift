//
//  CandidateListView.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import SwiftUI

struct CandidateListView: View {
    @StateObject private var viewModel = CandidateListViewModel(onSignOut: { })
    @State private var showingCreateCandidate = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                headerView()
                
                if viewModel.inProgress {
                    ProgressView("Loading candidates...")
                        .padding()
                } else {
                    candidateList()
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                
                if !viewModel.inEditMode {
                    createCandidateButton()
                }
            }
            .padding()
            .onAppear {
                viewModel.getCandidates()
            }
            .navigationTitle("Candidates")
        }
    }
    
    private func headerView() -> some View {
        HStack(spacing: 15) {
            Button(action: { viewModel.editModeToggle() }) {
                Label(
                    viewModel.inEditMode ? "Return" : "Edit",
                    systemImage: viewModel.inEditMode ? "arrow.uturn.backward.circle.fill" : "pencil.circle.fill"
                )
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            
            TextField("Search by name or surname", text: $viewModel.filter.search)
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            if viewModel.inEditMode {
                Button(action: { viewModel.deleteSelection() }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            } else {
                Button(action: { viewModel.filter.favorites.toggle() }) {
                    Image(systemName: viewModel.filter.favorites ? "star.fill" : "star")
                        .foregroundColor(viewModel.filter.favorites ? .yellow : .gray)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    private func candidateList() -> some View {
        List {
            ForEach(viewModel.candidates) { candidate in
                if let index = viewModel.candidates.firstIndex(where: { $0.id == candidate.id }) {
                    if viewModel.inEditMode {
                        CandidateRowView(
                            candidate: candidate,
                            isInEditMode: viewModel.inEditMode,
                            isSelected: viewModel.selection.contains(candidate.id),
                            toggleSelection: {
                                if viewModel.selection.contains(candidate.id) {
                                    viewModel.selection.remove(candidate.id)
                                } else {
                                    viewModel.selection.insert(candidate.id)
                                }
                            }
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if viewModel.selection.contains(candidate.id) {
                                viewModel.selection.remove(candidate.id)
                            } else {
                                viewModel.selection.insert(candidate.id)
                            }
                        }
                    } else {
                        NavigationLink(
                            destination: CandidateDetailView(
                                candidate: $viewModel.candidates[index],
                                token: AuthenticationManager.shared.getToken() ?? "",
                                isAdmin: viewModel.isAdmin
                            )
                        ) {
                            CandidateRowView(
                                candidate: candidate,
                                isInEditMode: viewModel.inEditMode,
                                isSelected: viewModel.selection.contains(candidate.id),
                                toggleSelection: {
                                }
                            )
                        }
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    
    private func createCandidateButton() -> some View {
        Button(action: {
            showingCreateCandidate.toggle()
        }) {
            Text("+ New Candidate")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
        }
        .padding()
        .sheet(isPresented: $showingCreateCandidate) {
            CreateCandidateView()
        }
    }
}
