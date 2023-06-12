//
//  MessagingChatsView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct MessagingChatsView: View {
    
    @ObservedObject var viewModel: MessagingChatsViewModel

    @State private var isPresentedConversation: Bool = false
    
    let rowSpacing: CGFloat = 5.0
    
    var filteredList: [Chat] {
        if viewModel.searchText.isEmpty {
            return viewModel.list
        }
        else {
            return viewModel.list.filter { $0.title.localizedCaseInsensitiveContains(viewModel.searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<filteredList.count, id: \.self) { index in
                    let item = filteredList[index]
                    Button {
                        logger.info(message: "selected-item index: \(index)")
                        
                        viewModel.selectedIndex = index
                        isPresentedConversation.toggle()
                        
                    } label: {
                        ChatRow(chat: item)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 5)
                        .padding(EdgeInsets(top: rowSpacing,
                                            leading: rowSpacing,
                                            bottom: rowSpacing,
                                            trailing: rowSpacing))
                        .background(.clear)
                        .foregroundColor(.white)
                )
            }
            .listStyle(.plain)
            .padding(.all, 5)
            .background(ColorNames.listBackgroundColor.colorValue)
            .fullScreenCover(isPresented: $isPresentedConversation) {
                ConversationsView(title: viewModel.list[viewModel.selectedIndex].title)
            }
        }
        
    }
}

struct MessagingChatsView_Previews: PreviewProvider {
    static var previews: some View {
        MessagingChatsView(viewModel: MessagingChatsViewModel())
    }
}
