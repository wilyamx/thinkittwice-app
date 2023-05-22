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
    
    var filteredList: [Notification] {
        if searchText.isEmpty {
            return viewModel.list
        }
        else {
            return viewModel.list.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        let _ = Self._printChanges()
        
        NavigationStack {
            VStack() {
                List {
                    ForEach(Array(filteredList.enumerated()), id: \.offset) { index, notification in
                        NotificationRow(list: $viewModel.list,
                                        notification: notification)
                    }
                    .listRowSeparator(.visible)
                }
                .listStyle(.inset)
                
                Spacer()
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.white, for: .navigationBar)
            .onAppear {
                viewModel.getList()
            }
        }
        .searchable(text: $searchText, prompt: "Search from title")
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
            .environmentObject(NotificationsViewModel())
    }
}
