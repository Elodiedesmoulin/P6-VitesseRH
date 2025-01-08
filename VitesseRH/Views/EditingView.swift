//
//  EditingView.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import SwiftUI


struct EditingView: View {
    @Binding var candidate: Candidate
    @ObservedObject var viewModel: EditingViewModel
    @Binding var isEditing: Bool
    
    var body: some View {
        VStack {
            Text("Edit Candidate")
                .font(.headline)
                .bold()
            
            TextField("First Name", text: $candidate.firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Last Name", text: $candidate.lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Email", text: $candidate.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Phone", text: $candidate.phone)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("LinkedIn", text: Binding(
                get: { candidate.linkedinURL ?? "" },
                set: { candidate.linkedinURL = $0 }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            TextField("Note", text: Binding(
                get: { candidate.note ?? "" },
                set: { candidate.note = $0 }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button("Save Changes") {
                viewModel.saveChanges(for: candidate)
                if viewModel.errorMessage == nil {
                    isEditing = false
                }
            }
            .padding()
        }
        .padding()
    }
}
