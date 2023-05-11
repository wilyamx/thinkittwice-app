//
//  LandingScreen.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/9/23.
//

import SwiftUI

struct LandingScreen: View {
    @EnvironmentObject var tabViewModel: TabViewModel
    @EnvironmentObject var feedsViewModel: FeedsViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        if profileViewModel.isLoggedOut {
            LoginScreen()
        }
        else {
            TabView {
                FeedsView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Feeds")
                    }
                    .environmentObject(FeedsViewModel())
                NotificationsView()
                    .tabItem {
                        Image(systemName: "note")
                        Text("Notifications")
                    }
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
            .environmentObject(TabViewModel())
            .environmentObject(FeedsViewModel())
            .environmentObject(ProfileViewModel())
    }
}
