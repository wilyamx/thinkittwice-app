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
                .navigationTitle("Primary View")
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
