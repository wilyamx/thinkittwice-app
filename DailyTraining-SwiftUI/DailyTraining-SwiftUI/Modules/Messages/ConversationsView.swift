//
//  ConversationsView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/21/23.
//

import SwiftUI

struct ConversationsView: View {
    
    @State private var message: String = ""
    
    var title: String
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            ConversationListView(title: title)
            
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "camera")
                        .font(.title)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "paperclip")
                        .font(.title)
                }
                
                TextField("Send a message...", text: $message)
                    .padding()
                    .background(Color("ListBackgroundColor"))
                    .multilineTextAlignment(.leading)
                    .cornerRadius(16)
                
                Button {
                    
                } label: {
                    Image(systemName: "paperplane")
                        .font(.title)
                }
            }
            .padding()
            .background(.white)
            
            Spacer()
        }
        .background(.white)
//        .toolbar {
//            ToolbarItemGroup(placement: .keyboard) {
//                Button("Done") {
//
//                }
//            }
//        }
        
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsView(title: "Conversations")
    }
}
