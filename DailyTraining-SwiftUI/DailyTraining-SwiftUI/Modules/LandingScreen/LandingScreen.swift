//
//  LandingScreen.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/9/23.
//

import SwiftUI

struct LandingScreen: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        let _ = Self._printChanges()
        
        if profileViewModel.isLoggedOut {
            LoginScreen()
                .environmentObject(LoginViewModel())
        }
        else {
            TabView {
                FeedsView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Feeds")
                    }
                    .badge(14)
                    .environmentObject(FeedsViewModel())
                
                NotificationsView()
                    .tabItem {
                        Image(systemName: "note")
                        Text("Notifications")
                    }
                    .badge("!")
                    .environmentObject(NotificationsViewModel())
                
                MessagingView()
                    .tabItem {
                        Image(systemName: "message.badge")
                        Text("Messages")
                    }
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
            }
            .accentColor(.green)
        }
    }
}

struct LandingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LandingScreen()
            .environmentObject(FeedsViewModel())
            .environmentObject(ProfileViewModel())
    }
}
