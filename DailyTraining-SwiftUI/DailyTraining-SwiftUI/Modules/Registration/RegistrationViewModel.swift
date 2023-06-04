//
//  RegistrationViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/4/23.
//

import Foundation
import RealmSwift

final class RegistrationViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var birthdate = Date()
    @Published var shouldSendNewsLetter = false
    @Published var yearsOfExperience = 0
    @Published var password = ""
    
    @ObservedResults(User.self) var users
    
    func register() -> Bool {
        guard !firstName.isEmpty else {
            return false
        }
        guard !lastName.isEmpty else {
            return false
        }
        guard !email.isEmpty, email.isValidEmail() else {
            return false
        }
        
        let user = User()
        user.firstName = firstName
        user.lastName = lastName
        user.email = email.lowercased()
        user.password = password
        
        $users.append(user)
        
        return true
    }
}
