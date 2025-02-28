//
//  EditingView.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import SwiftUI

struct EditingView: View {
    @ObservedObject var viewModel: EditingViewModel
    @Binding var isEditing: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Candidate")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 20)
            VStack(spacing: 15) {
                EditableRow(label: "First Name", text: $viewModel.candidate.firstName)
                EditableRow(label: "Last Name", text: $viewModel.candidate.lastName)
                EditableRow(label: "Email", text: $viewModel.candidate.email)
                EditableRow(label: "Phone", text: $viewModel.candidate.phone)
                EditableRow(label: "LinkedIn", text: Binding(get: { viewModel.candidate.linkedinURL ?? "" }, set: { viewModel.candidate.linkedinURL = $0 }))
                EditableRow(label: "Note", text: Binding(get: { viewModel.candidate.note ?? "" }, set: { viewModel.candidate.note = $0 }))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            Button("Save Changes") {
                Task {
                    await viewModel.saveChanges()
                    if viewModel.errorMessage == nil {
                        isEditing = false
                        NotificationCenter.default.post(name: .needUpdate, object: nil)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
        .padding()
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

