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
    
    @Published var validatedUser: Bool = false
    
    @ObservedResults(User.self) var users
    
    public func register() {
        requestStarted(message: "Registering User")
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 2,
            execute: {
                let isValidUser = self.isValidCredential()
                if isValidUser {
                    self.requestSuccess()
                }
                else {
                    self.requestFailed(
                        reason: String.empty,
                        errorAlertType: .custom(self.errorMessage)
                    )
                }
                self.validatedUser = isValidUser
            })
    }
    
    private func isValidCredential() -> Bool {
        // validation
        guard !firstName.isEmpty else {
            self.errorMessage = String.invalid_registrations
            return false
        }
        guard !lastName.isEmpty else {
            self.errorMessage = String.invalid_registrations
            return false
        }
        guard !email.isEmpty, email.isValidEmail() else {
            self.errorMessage = String.invalid_email
            return false
        }
        guard !password.isEmpty, password.count > 8 else {
            self.errorMessage = String.invalid_registrations
            return false
        }
        
        // check if registered user
        if isRegisteredUser() {
            self.errorMessage = String.registered_user
            return false
        }
        else {
            self.errorMessage = String.empty
            
            let user = User()
            user.firstName = firstName
            user.lastName = lastName
            user.email = email.lowercased()
            user.password = password
            
            $users.append(user)
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
