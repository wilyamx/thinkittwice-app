//
//  LandingScreen.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/9/23.
//

import SwiftUI

struct LandingScreen: View {
    let profileViewModel = ProfileViewModel()
    let notificationsViewModel = NotificationsViewModel()
    
    var body: some View {
        if profileViewModel.isLoggedOut {
            LoginView()
                .environmentObject(LoginViewModel())
        }
        else {
            TabView {
                FeedsView()
                    .tabItem {
                        Image(systemName: "house")
                        Text(LocalizedStringKey(String.feeds))
                    }
                    .badge(14)
                    .environmentObject(FeedsViewModel())
                    .environmentObject(notificationsViewModel)
                
                NotificationsView()
                    .tabItem {
                        Image(systemName: "note")
                        Text(LocalizedStringKey(String.notifications))
                    }
                    .badge("!")
                    .environmentObject(notificationsViewModel)
                
                MessagingView()
                    .tabItem {
                        Image(systemName: "message.badge")
                        Text(LocalizedStringKey(String.messages))
                    }
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person")
                        Text(LocalizedStringKey(String.profile))
                    }
                    .environmentObject(profileViewModel)
            }
            .accentColor(ColorNames.accentColor.colorValue)
        }
    }
}

struct LandingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LandingScreen()
            .environmentObject(FeedsViewModel())
            .environmentObject(ProfileViewModel())
            .environment(\.locale, .init(identifier: "ar"))
    }
}
