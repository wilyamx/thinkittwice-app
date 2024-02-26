//
//  TestView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/8/23.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        TabView {
            NavigationStack {
                NavigationLink("Tap Me") {
                    Text("Detail View")
                        .toolbar(.hidden, for: .tabBar)
                }
                .navigationTitle("Channel")
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
        }
    }
}

#Preview("English") {
    TestView()
        .environment(\.locale, Locale(identifier: "en"))
}

#Preview("French") {
    TestView()
        .environment(\.locale, Locale(identifier: "fr"))
}

#Preview("Arabic") {
    TestView()
        .environment(\.locale, Locale(identifier: "ar"))
}
