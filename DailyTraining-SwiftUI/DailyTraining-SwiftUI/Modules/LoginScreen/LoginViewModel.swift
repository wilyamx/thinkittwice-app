//
//  LoginViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/12/23.
//

import Foundation

final class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    
    @Published var isValidCredentials = false
    
    func login() {
        isValidCredentials = !username.isEmpty && !password.isEmpty
    }
}
