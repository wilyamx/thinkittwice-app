//
//  MessagingChatsView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct MessagingChatsView: View {
    
    @EnvironmentObject var viewModel: MessagingChatsViewModel
    
    @State private var selectedListIndex: Int = 0
    @State private var isPresentedConversation: Bool = false
    
    let rowSpacing: CGFloat = 5.0
    
    var body: some View {
        let _ = Self._printChanges()
        
        NavigationStack {
            List {
                ForEach(0..<viewModel.list.count, id: \.self) { index in
                    let item = viewModel.list[index]
                    Button {
                        selectedListIndex = index
                        
                        logger.log(logKey: .info, category: "MessagingChatsView", message: "selected-item index: \(index), id: \(item.id)")
                        logger.log(logKey: .info, category: "MessagingChatsView", message: "selected-index index: \(selectedListIndex)")
                        
                        
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
            .background(Color(ColorNames.listBackgroundColor.rawValue))
            .onAppear {
                logger.log(logKey: .info, any: viewModel, message: "onAppear")
                viewModel.getChats()
            }
            .fullScreenCover(isPresented: $isPresentedConversation) {
                ConversationsView(title: viewModel.list[selectedListIndex].title)
            }
        }
        
    }
}

struct MessagingChatsView_Previews: PreviewProvider {
    static var previews: some View {
        MessagingChatsView()
            .environmentObject(MessagingChatsViewModel())
    }
}
