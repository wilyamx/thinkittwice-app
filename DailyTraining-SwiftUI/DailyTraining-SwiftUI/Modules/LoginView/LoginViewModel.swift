//
//  LoginViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/12/23.
//

import Foundation
import RealmSwift

final class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    
    @Published var isValidCredentials: Bool = false
    @Published var showingAlert: Bool = false
    @Published var isSecured: Bool = true
    
    @Published var isReturneeUser: Bool = false
    
    @ObservedResults(User.self) var registeredUsers
    
    func login() {
        
        // entry validation
        
        guard !username.isEmpty, username.isValidEmail() else {
            showingAlert = true
            return
        }
        
        guard !password.isEmpty, password.count > 8 else {
            showingAlert = true
            return
        }
        
        guard registeredUsers.count > 0 else {
            showingAlert = true
            return
        }
        
        // user validation
        
        let userList = registeredUsers.where({ $0.email == username })
        
        guard userList.count ==  1 else {
            showingAlert = true
            return
        }
                
        guard let user = userList.first,
            user.email == username.lowercased(),
            user.password == password else {
            showingAlert = true
            return
        }
        
        isValidCredentials = true
    }

    func checkForReturneeUser() {
        isReturneeUser = registeredUsers.count > 0
    }
}
