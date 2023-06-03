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
    
    @Published var validUserEntries = false
    
    @ObservedResults(User.self) var users
    
    func register() {
        guard !firstName.isEmpty else {
            validUserEntries = false
            return
        }
        guard !lastName.isEmpty else {
            validUserEntries = false
            return
        }
        
        let user = User()
        user.firstName = firstName
        user.lastName = lastName
        user.email = email
        
        $users.append(user)
    }
}
