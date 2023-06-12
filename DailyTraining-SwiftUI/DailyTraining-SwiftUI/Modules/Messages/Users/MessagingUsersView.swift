//
//  MessagingUsersView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct MessagingUsersView: View {
    
    @ObservedObject var viewModel:MessagingUsersViewModel
    
    let rowSpacing: CGFloat = 5.0
    
    var filteredList: [ChatUser] {
        if viewModel.searchText.isEmpty {
            return viewModel.list
        }
        else {
            return viewModel.list.filter { $0.title.localizedCaseInsensitiveContains(viewModel.searchText) }
        }
    }
    
    var body: some View {
        VStack {
            List() {
                ForEach(0..<filteredList.count, id: \.self) { index in
                    let item = filteredList[index]
                    Button {
                        logger.info(message: "selected-item index: \(index), id: \(item.id)")
                    } label: {
                        ChatUserRow(user: item)
                    }
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 5)
                        .padding(EdgeInsets(top: rowSpacing,
                                            leading: rowSpacing,
                                            bottom: rowSpacing,
                                            trailing: rowSpacing))
                        .background(.clear)
                        .foregroundColor(.white)
                    
                )
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .padding(.all, 5)
            .background(Color(UIColor(red: 246/255,
                                      green: 246/255,
                                      blue: 246/255,
                                      alpha: 1.0)))
        }
    }
}

struct MessagingUsersView_Previews: PreviewProvider {
    static var previews: some View {
        MessagingUsersView(viewModel: MessagingUsersViewModel())
    }
}
