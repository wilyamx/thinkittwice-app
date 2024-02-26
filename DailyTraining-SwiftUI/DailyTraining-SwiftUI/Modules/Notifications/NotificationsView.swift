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
            return viewModel.list.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    /**
            We don't need to show progress view because data was loaded locally
     */
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(Array(filteredList.enumerated()), id: \.offset) { index, notification in
                        NotificationRow(list: $viewModel.list,
                                        notification: notification)
                    }
                    .listRowSeparator(.visible)
                }
                .listStyle(.inset)
                .buttonStyle(.borderless)
                
                Spacer()
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.white, for: .navigationBar)
            .onAppear {
                viewModel.getList()
            }
        }
        .searchable(
            text: $searchText,
            prompt: LocalizedStringKey(String.search_from_title))
        .onChange(of: viewModel.list) {
            viewModel.sortList()
            logger.info(message: "Notification list onChange: \(viewModel.list.count)")
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
            .environmentObject(NotificationsViewModel())
            .environment(\.locale, .init(identifier: "ar"))
    }
}
