//
//  NotificationsView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct NotificationsView: View {
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0 ..< 15) { item in
                    NotificationRow()
                }
                .listRowSeparator(.visible)
            }
            .listStyle(.inset)
            
            .searchable(text: $searchText)
            .onChange(of: searchText) { searchText in
                print("[Debug] New search text: \(searchText)")
            }
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
