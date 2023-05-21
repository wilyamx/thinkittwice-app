//
//  NotificationsView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject var viewModel: NotificationsViewModel
    
    @State private var searchText: String = ""
    
    var body: some View {
        let _ = Self._printChanges()
        
        NavigationStack {
            VStack() {
                List {
                    ForEach(viewModel.list, id: \.id) { notification in
                        NotificationRow(notification: notification)
                    }
                    .listRowSeparator(.visible)
                }
                .listStyle(.inset)
                
                .searchable(text: $searchText)
                .onChange(of: searchText) { searchText in
                    logger.log(logKey: .info, category: "NotificationView", message: "New search text: \(searchText)")
                }
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(.white, for: .navigationBar)
                
                Spacer()
            }
            .onAppear {
                viewModel.getList()
            }
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
            .environmentObject(NotificationsViewModel())
    }
}
