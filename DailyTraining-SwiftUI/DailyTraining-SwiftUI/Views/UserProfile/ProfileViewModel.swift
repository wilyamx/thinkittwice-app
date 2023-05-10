//
//  ProfileViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/8/23.
//

import Foundation

final class ProfileViewModel: ObservableObject {
    @Published var isLoggedOut: Bool = false
    
    func logout() {
        print("[DebugMode] [ProfileViewModel] logging out...")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("[DebugMode] [ProfileViewModel] logged-out!")
            self.isLoggedOut = true
        }
    }
}
