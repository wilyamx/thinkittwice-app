//
//  MessagingChatsView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct MessagingChatsView: View {
    @StateObject private var viewModel = MessagingChatsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.chats) { chat in
                ChatRow(chat: chat)
            }
        }
    }
}

struct MessagingChatsView_Previews: PreviewProvider {
    static var previews: some View {
        MessagingChatsView()
    }
}
