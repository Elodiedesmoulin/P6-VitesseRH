//
//  CreateCandidateListView.swift
//  VitesseRH
//
//  Created by Elo on 06/01/2025.
//

import Foundation

final class CreateCandidateViewModel: ObservableObject {
    private let service = VitesseRHService()
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var linkedinURL: String = ""
    @Published var note: String = ""
    
    @Published private(set) var addInProgress = false
    @Published private(set) var dismissView = false
    @Published private(set) var errorMessage = ""
    
    var detailsHaveBeenEdited: Bool {
        ![firstName, lastName, email, linkedinURL, phone, note].allSatisfy { $0.isEmpty }
    }
    
    func addCandidate() {
        guard textfieldsAreValid() else { return }
        addInProgress = true
        let newCandidate = Candidate(
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
            let result = await service.addCandidate(candidate: newCandidate)
            await processResult(result)
        }
    }
    
    private func processResult(_ result: Result<Candidate, VitesseRHError>) async {
        await MainActor.run {
            switch result {
            case .success:
                NotificationCenter.default.post(name: .needUpdate, object: nil)
                self.dismissView = true
            case .failure(let error):
                self.errorMessage = "\(error.title) \(error.localizedDescription)"
            }
            self.addInProgress = false
        }
    }
    
    private func textfieldsAreValid() -> Bool {
        guard !firstName.isEmpty, !lastName.isEmpty else {
            errorMessage = VitesseRHError.validation(.invalidName).localizedDescription
            return false
        }
        guard !email.isEmpty else {
            errorMessage = VitesseRHError.validation(.emptyEmail).localizedDescription
            return false
        }
        guard email.isValidEmail() else {
            errorMessage = VitesseRHError.validation(.invalidEmail).localizedDescription
            return false
        }
        if !phone.isEmpty, !phone.isValidFrPhone() {
            errorMessage = VitesseRHError.validation(.invalidPhone).localizedDescription
            return false
        }
        if !linkedinURL.isEmpty, URL(string: linkedinURL) == nil {
            errorMessage = VitesseRHError.validation(.invalidLinkedInURL).localizedDescription
            return false
        }
        
        return true
    }
}
