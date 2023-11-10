//
//  LoginViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/12/23.
//

import Foundation
import RealmSwift

final class LoginViewModel: WSRFetcher2 {
        
    @Published var username: String = String.empty
    @Published var password: String = String.empty
    
    // show invalid credential alert
    @Published var showingAlert: Bool = false
    // hide or show password
    @Published var isSecured: Bool = true
    
    @Published var isReturneeUser: Bool = false
    
    @ObservedResults(User.self) var registeredUsers
    
    func login() {
        requestStarted(message: "Logging in")
    
        // entry validation
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 2,
            execute: {
                self.validate()
            })
    }

    private func validate() {
        guard !username.isEmpty, username.isValidEmail() else {
            errorMessage = String.invalid_email
            requestFailed(reason: String.email, errorAlertType: .custom(self.errorMessage))
            return
        }
        
        guard !password.isEmpty, password.count > 8 else {
            errorMessage = String.invalid_password
            requestFailed(reason: String.email, errorAlertType: .custom(self.errorMessage))
            return
        }
        
        // user validation
        
        let userList = registeredUsers.where({ $0.email == username })
        
        guard userList.count ==  1 else {
            errorMessage = String.invalid_credentials
            requestFailed(reason: String.empty, errorAlertType: .custom(self.errorMessage))
            showingAlert = true
            return
        }
                
        guard let user = userList.first,
            user.email == username.lowercased(),
            user.password == password else {
            
            errorMessage = String.invalid_credentials
            requestFailed(reason: String.empty, errorAlertType: .custom(errorMessage))
            showingAlert = true
            return
        }
        
        UserDefaults.standard.set(username,
                                  forKey: WSRUserDefaultsKey.email.rawValue)
        UserDefaults.standard.set(true,
                                  forKey: WSRUserDefaultsKey.isLoggedOut.rawValue)
        
        requestSuccess()
    }
    
    func checkForReturneeUser() {
        // if logged out we force the user to login
        if UserDefaults.standard.bool(forKey: WSRUserDefaultsKey.isLoggedOut.rawValue) {
            if let _ = registeredUsers.first(where: {
                $0.email == username
            }) {
                isReturneeUser = false
            }

            isReturneeUser = true
            return
        }
        
        isReturneeUser = false
    }
}
