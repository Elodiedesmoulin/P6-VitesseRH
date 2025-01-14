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
                .padding(.bottom, 20)

            VStack(spacing: 15) {
                TextField("First Name", text: $candidate.firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled(true)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)

                TextField("Last Name", text: $candidate.lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled(true)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)

                TextField("Email", text: $candidate.email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)

                TextField("Phone", text: $candidate.phone)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)

                TextField("LinkedIn", text: Binding(
                    get: { candidate.linkedinURL ?? "" },
                    set: { candidate.linkedinURL = $0 }
                ))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)

                TextField("Note", text: Binding(
                    get: { candidate.note ?? "" },
                    set: { candidate.note = $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
            }

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

    }
}
