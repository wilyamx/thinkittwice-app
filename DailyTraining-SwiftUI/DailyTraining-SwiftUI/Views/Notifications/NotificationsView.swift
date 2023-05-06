//
//  NotificationsView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(0 ..< 15) { item in
                    NotificationRow()
                }
                .listRowSeparator(.visible)
            }
            .listStyle(.inset)
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}