//
//  RegistrationViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/4/23.
//

import Foundation
import RealmSwift

final class RegistrationViewModel: ObservableObject, WSRViewStateProtocol {
    
    @Published var viewState: WSRViewState = .empty
    var loadingMessage: String = String.empty
    var errorMessage: String = String.empty
    var errorAlertType: WSRErrorAlertType = .none
    
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var birthdate = Date()
    @Published var shouldSendNewsLetter = false
    @Published var yearsOfExperience = 0
    @Published var password = ""
    
    @Published var showErrorAlert = false
    
    @ObservedResults(User.self) var users
    
    public func register() -> Bool {
        viewState = .loading
        
        // validation
        guard !firstName.isEmpty else {
            errorMessage = String.invalid_registrations
            viewState = .error
            showErrorAlert = true
            return false
        }
        guard !lastName.isEmpty else {
            errorMessage = String.invalid_registrations
            viewState = .error
            showErrorAlert = true
            return false
        }
        guard !email.isEmpty, email.isValidEmail() else {
            errorMessage = String.invalid_email
            viewState = .error
            showErrorAlert = true
            return false
        }
        
        // check if registered user
        if isRegisteredUser() {
            errorMessage = String.registered_user
            viewState = .error
            showErrorAlert = true
            return false
        }
        else {
            let user = User()
            user.firstName = firstName
            user.lastName = lastName
            user.email = email.lowercased()
            user.password = password
            
            $users.append(user)
            
            errorMessage = String.empty
            viewState = .populated
            showErrorAlert = false
            return true
        }
    }
    
    private func isRegisteredUser() -> Bool {
        guard let user = users.first(where: {
            $0.email == email
        }) else {
            return false
        }
        
        return true
    }
}
