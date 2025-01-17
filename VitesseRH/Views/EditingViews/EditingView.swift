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
        VStack(spacing: 20) {
            Text("Edit Candidate")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 20)
            
            VStack(spacing: 15) {
                EditableRow(label: "First Name", text: $candidate.firstName)
                EditableRow(label: "Last Name", text: $candidate.lastName)
                EditableRow(label: "Email", text: $candidate.email)
                EditableRow(label: "Phone", text: $candidate.phone)
                EditableRow(label: "LinkedIn", text: Binding(
                    get: { candidate.linkedinURL ?? "" },
                    set: { candidate.linkedinURL = $0 }
                ))
                EditableRow(label: "Note", text: Binding(
                    get: { candidate.note ?? "" },
                    set: { candidate.note = $0 }
                ))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.gray.opacity(0.1), radius: 10, x: 0, y: 5)
            
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
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
        }
        .padding()
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}
