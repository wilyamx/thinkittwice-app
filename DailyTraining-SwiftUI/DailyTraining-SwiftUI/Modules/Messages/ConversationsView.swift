//
//  ConversationsView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/21/23.
//

import SwiftUI

struct ConversationsView: View {
    @ObservedObject var viewModel = ConversationsViewModel()
    
    var body: some View {
        NavigationStack {
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
            }
            .listStyle(.plain)
            .navigationTitle("Conversation")
            .navigationDestination(for: Conversation.self) { conversation in
                ConversationRow(conversation: conversation)
            }
        }
        .onAppear {
            viewModel.getList()
        }
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsView()
    }
}
