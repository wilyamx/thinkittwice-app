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
                
                NotificationsView()
                    .tabItem {
                        Image(systemName: "note")
                        Text(LocalizedStringKey(String.notifications))
                    }
                    .badge("!")
                    .environmentObject(NotificationsViewModel())
                
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
