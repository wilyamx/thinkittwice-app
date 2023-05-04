//
//  ContentView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DailyTrainingViewModel()
    
    var body: some View {
        TabView {
            FeedsView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Feeds")
                }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
