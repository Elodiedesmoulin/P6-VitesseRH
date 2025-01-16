//
//  DetailView.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import SwiftUI

struct DetailView: View {
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
            .background(Color("BackgroundGray"))
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

struct CandidateDetailHeader: View {
    @Binding var candidate: Candidate
    let toggleFavorite: () -> Void
    var isAdmin: Bool  

    var body: some View {
        HStack {
            Text("\(candidate.firstName) \(candidate.lastName)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Spacer()

            if isAdmin {
                Button(action: {
                    candidate.isFavorite.toggle()
                    toggleFavorite()
                }) {
                    Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                        .foregroundColor(candidate.isFavorite ? .yellow : .gray)
                }
            } else {
                Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                    .foregroundColor(candidate.isFavorite ? .yellow : .gray)
                    .opacity(0.5)
            }
        }
        .padding(.bottom, 15)
    }
}

struct CandidateDetailInfo: View {
    let candidate: Candidate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CandidateInfoRow(label: "Email", value: candidate.email, isLarge: false)
            CandidateInfoRow(label: "Phone", value: candidate.phone, isLarge: false)
            CandidateInfoRow(label: "LinkedIn", value: candidate.linkedinURL ?? "Not provided", isLarge: false)
        }
        .padding(.horizontal)
    }
}

struct CandidateInfoRow: View {
    let label: String
    let value: String
    let isLarge: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
            
            TextField("", text: .constant(value))
                .font(isLarge ? .title2 : .body)
                .foregroundColor(.black)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                        .background(Color.white)
                )
                .frame(height: isLarge ? 40 : 30)
        }
    }
}

struct NoteView: View {
    let candidate: Candidate
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Note")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 5)
                Spacer()
            }
            HStack {
                Text(candidate.note ?? "Not provided")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.body)
            }
            .padding(8)
            .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
                    .background(Color.white)
            )
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
    }
}

#Preview(body: {
    DetailView(candidate: .constant(Candidate(id: "dfghj", firstName: "Elo", lastName: "Desm", email: "elo.desl@icloud.com", phone: "0660123626", isFavorite: true)) , token: "fghjkl", isAdmin: true)
})
