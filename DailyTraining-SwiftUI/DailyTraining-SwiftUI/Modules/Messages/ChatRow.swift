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
            switch ChannelType(rawValue: chat.type) {
            case .topic:
                ZStack {
                    Circle()
                        .foregroundColor(Color(UIColor.lightGray))
                    Image(systemName: "number")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                        .imageScale(.small)
                }
                .frame(height: 60)
                .clipShape(Circle())
                
            case .single:
                ZStack {
                    Circle()
                        .foregroundColor(Color(UIColor.lightGray))
                    Image(systemName: "person")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                        .imageScale(.small)
                }
                .frame(height: 60)
                .clipShape(Circle())
                
            case .group:
                ZStack {
                    Circle()
                        .foregroundColor(Color(UIColor.lightGray))
                    Image(systemName: "person.3")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                        .imageScale(.small)
                }
                .frame(height: 60)
                .clipShape(Circle())
                
            case .none, .event:
                Image(chat.avatar)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(height: 60)
            }
            
            VStack(alignment: .leading) {
                Text(chat.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                Text(chat.message)
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            
            Spacer()
            
            ZStack {
                Rectangle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
                    .cornerRadius(8)
                Text("\(chat.unread)")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(EdgeInsets(top: -28, leading: 0, bottom: 0, trailing: -8))
        }
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(chat: MessagingChatsViewModel().list[2])
    }
}
