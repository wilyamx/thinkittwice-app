//
//  ProfileViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/8/23.
//

import SwiftUI
import RealmSwift

final class ProfileViewModel: ObservableObject {
    @Published var isLoggedOut: Bool = false
    @Published var logoutButtonAction: String = "Logout"
    
    @Environment(\.realm) var realm
    @ObservedResults(User.self) var registeredUsers
    
    func getUserDetails() {
        
    }
    
    func logout() {
        self.logoutButtonAction = "Logging out..."
        
        logger.realm(message: "Deleting all registered users!")
        registeredUsers.forEach { user in
            try! realm.write {
                realm.delete(user)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isLoggedOut = true
        }
    }
}
