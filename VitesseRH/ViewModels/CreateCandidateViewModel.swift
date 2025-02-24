//
//  CreateCandidateListView.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

final class CreateCandidateViewModel: ObservableObject {
    private let service: VitesseRHServiceProtocol
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var linkedinURL = ""
    @Published var note = ""
    
    @Published private(set) var isAdding = false
    @Published private(set) var dismissView = false
    @Published private(set) var errorMessage = ""
    
    var isEdited: Bool {
        ![firstName, lastName, email, linkedinURL, phone, note].allSatisfy { $0.isEmpty }
    }
    
    init(service: VitesseRHServiceProtocol = VitesseRHService()) {
        self.service = service
    }
    
    func addCandidate() {
        guard areTextFieldsValid() else { return }
        isAdding = true
        let candidate = Candidate(
            id: "",
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            note: note,
            linkedinURL: linkedinURL,
            isFavorite: false
        )
        Task {
            let result = await service.addCandidate(candidate: candidate)
            await handleResult(result)
        }
    }
    
    private func handleResult(_ result: Result<Candidate, VitesseRHError>) async {
        await MainActor.run {
            switch result {
            case .success:
                NotificationCenter.default.post(name: .needUpdate, object: nil)
                dismissView = true
            case .failure(let error):
                errorMessage = "\(error.title) \(error.localizedDescription)"
            }
            isAdding = false
        }
    }
    
    private func areTextFieldsValid() -> Bool {
        if firstName.isEmpty || lastName.isEmpty {
            errorMessage = VitesseRHError.validation(.invalidName).localizedDescription
            return false
        }
        if email.isEmpty {
            errorMessage = VitesseRHError.validation(.emptyEmail).localizedDescription
            return false
        }
        if !email.isValidEmail() {
            errorMessage = VitesseRHError.validation(.invalidEmail).localizedDescription
            return false
        }
        if !phone.isEmpty && !phone.isValidFrPhone() {
            errorMessage = VitesseRHError.validation(.invalidPhone).localizedDescription
            return false
        }
        if !linkedinURL.isEmpty, URL(string: linkedinURL)?.scheme == nil {
            errorMessage = VitesseRHError.validation(.invalidLinkedInURL).localizedDescription
            return false
        }
        return true
    }
}
