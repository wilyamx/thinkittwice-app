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
    
    @ObservedResults(User.self) var users
    
    func login() {
        guard !username.isEmpty, username.isValidEmail() else {
            showingAlert = true
            return
        }
        
        guard !password.isEmpty, password.count > 8 else {
            showingAlert = true
            return
        }
        
        isValidCredentials = true
    }
}
