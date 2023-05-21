//
//  ConversationListView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/21/23.
//

import SwiftUI

struct ConversationListView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel = ConversationsViewModel()
    
    var title: String
        
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                List {
                    ForEach(viewModel.list, id: \.id) { conversation in
                        ZStack(alignment: .trailing) {
                            NavigationLink(value: conversation) {
                                ConversationRow(conversation: conversation)
                            }
                            .opacity(0)

                            ConversationRow(conversation: conversation)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 5)
                            .padding(EdgeInsets(top: 5,
                                                leading: 5,
                                                bottom: 5,
                                                trailing: 5))
                            .background(.clear)
                            .foregroundColor(.clear)
                    )
                }
                .background(Color("ListBackgroundColor"))
                .listStyle(.plain)
                .navigationTitle("\(title)")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: Conversation.self) { conversation in
                    ConversationRow(conversation: conversation)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                        })
                    }
                }
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(.white, for: .navigationBar)
                .onChange(of: viewModel.list) { newValue in
                    logger.log(logKey: .info, category: "ConversationsView", message: "\(newValue)")
                    proxy.scrollTo(newValue.last)
                }
            }
            
        }
        .onAppear {
            viewModel.getList()
        }
//        .toolbar {
//            ToolbarItemGroup(placement: .keyboard) {
//                Button("Done") {
//
//                }
//            }
//        }
        
    }
}

struct ConversationListView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationListView(title: "Conversations")
    }
}
