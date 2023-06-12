//
//  ConversationRow.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/21/23.
//

import SwiftUI

struct ConversationRow: View {
    var conversation: Conversation
    
    var body: some View {
        Text(conversation.message)
            .padding()
            .background(.black)
            .foregroundColor(.white)
            .multilineTextAlignment(.trailing)
            .cornerRadius(16)
    }
}

struct ConversationRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ConversationRow(conversation: Conversation.example())
        }
    }
}
