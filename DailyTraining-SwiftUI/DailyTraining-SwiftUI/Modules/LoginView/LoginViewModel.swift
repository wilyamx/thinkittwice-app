//
//  LoginViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/12/23.
//

import Foundation
import RealmSwift

final class LoginViewModel: ObservableObject, WSRViewStateProtocol {
    @Published var viewState: WSRViewState = .empty
    var loadingMessage: String = String.empty
    var errorMessage: String = String.empty
   
    @Published var username: String = String.empty
    @Published var password: String = String.empty
    
    // show invalid credential alert
    @Published var showingAlert: Bool = false
    // hide or show password
    @Published var isSecured: Bool = true
    
    @Published var isReturneeUser: Bool = false
    
    @ObservedResults(User.self) var registeredUsers
    
    func login() {
        viewState = .loading
        
        // entry validation
        
        guard !username.isEmpty, username.isValidEmail() else {
            errorMessage = String.invalid_email
            showingAlert = true
            viewState = .error
            return
        }
        
        guard !password.isEmpty, password.count > 8 else {
            errorMessage = String.invalid_password
            showingAlert = true
            viewState = .error
            return
        }
        
        // user validation
        
        let userList = registeredUsers.where({ $0.email == username })
        
        guard userList.count ==  1 else {
            errorMessage = String.invalid_credentials
            showingAlert = true
            viewState = .error
            return
        }
                
        guard let user = userList.first,
            user.email == username.lowercased(),
            user.password == password else {
            errorMessage = String.invalid_credentials
            showingAlert = true
            viewState = .error
            return
        }
        
        UserDefaults.standard.set(username,
                                  forKey: WSRUserDefaultsKey.email.rawValue)
        
        viewState = .populated
    }

    func checkForReturneeUser() {
        isReturneeUser = registeredUsers.count > 0
    }
}
