//
//  RegistrationViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/4/23.
//

import Foundation
import RealmSwift

final class RegistrationViewModel: WSRFetcher2 {
    
    @Published var firstName = String.empty
    @Published var lastName = String.empty
    @Published var email = String.empty
    @Published var birthdate = Date()
    @Published var shouldSendNewsLetter = false
    @Published var yearsOfExperience = 0
    @Published var password = String.empty
    
    @ObservedResults(User.self) var users
    
    public func register() -> Bool {
        requestStarted()
        
        // validation
        guard !firstName.isEmpty else {
            requestFailed(reason: String.invalid_registrations)
            showErrorAlert = true
            return false
        }
        guard !lastName.isEmpty else {
            requestFailed(reason: String.invalid_registrations)
            showErrorAlert = true
            return false
        }
        guard !email.isEmpty, email.isValidEmail() else {
            requestFailed(reason: String.invalid_email)
            showErrorAlert = true
            return false
        }
        guard !password.isEmpty, password.count > 8 else {
            requestFailed(reason: String.invalid_registrations)
            showErrorAlert = true
            return false
        }
        
        // check if registered user
        if isRegisteredUser() {
            requestFailed(reason: String.registered_user)
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
            
            requestSuccess()
            return true
        }
    }
    
    private func isRegisteredUser() -> Bool {
        guard let _ = users.first(where: {
            $0.email == email
        }) else {
            return false
        }
        
        return true
    }
}
