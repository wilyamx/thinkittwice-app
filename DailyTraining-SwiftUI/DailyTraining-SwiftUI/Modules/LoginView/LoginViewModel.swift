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
        
        guard !username.isEmpty, username.isValidEmail() else {
            requestFailed(reason: String.invalid_email)
            showingAlert = true
            return
        }
        
        guard !password.isEmpty, password.count > 8 else {
            requestFailed(reason: String.invalid_password)
            showingAlert = true
            return
        }
        
        // user validation
        
        let userList = registeredUsers.where({ $0.email == username })
        
        guard userList.count ==  1 else {
            requestFailed(reason: String.invalid_credentials)
            showingAlert = true
            return
        }
                
        guard let user = userList.first,
            user.email == username.lowercased(),
            user.password == password else {
            requestFailed(reason: String.invalid_credentials)
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
