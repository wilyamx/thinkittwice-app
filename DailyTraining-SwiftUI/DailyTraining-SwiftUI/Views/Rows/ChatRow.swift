//
//  ChatRow.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/4/23.
//

import SwiftUI

struct ChatRow: View {
    var chat: Chat
    
    var body: some View {
        HStack {
            Image(chat.avatar)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .frame(height: 60)
            
            VStack(alignment: .leading) {
                Text(chat.title)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(chat.message)
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(chat: MessagingChatsViewModel().chats.first!)
    }
}
