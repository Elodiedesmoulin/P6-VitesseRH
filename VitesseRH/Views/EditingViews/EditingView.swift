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
                EditableRow(label: "First Name", text: Binding(
                    get: { viewModel.$candidate.wrappedValue.firstName },
                    set: { viewModel.$candidate.wrappedValue.firstName = $0 }
                ))
                EditableRow(label: "Last Name", text: Binding(
                    get: { viewModel.$candidate.wrappedValue.lastName },
                    set: { viewModel.$candidate.wrappedValue.lastName = $0 }
                ))
                EditableRow(label: "Email", text: Binding(
                    get: { viewModel.$candidate.wrappedValue.email },
                    set: { viewModel.$candidate.wrappedValue.email = $0 }
                ))
                EditableRow(label: "Phone", text: Binding(
                    get: { viewModel.$candidate.wrappedValue.phone },
                    set: { viewModel.$candidate.wrappedValue.phone = $0 }
                ))
                EditableRow(label: "LinkedIn", text: Binding(
                    get: { viewModel.$candidate.wrappedValue.linkedinURL ?? "" },
                    set: { viewModel.$candidate.wrappedValue.linkedinURL = $0 }
                ))
                EditableRow(label: "Note", text: Binding(
                    get: { viewModel.$candidate.wrappedValue.note ?? "" },
                    set: { viewModel.$candidate.wrappedValue.note = $0 }
                ))
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

