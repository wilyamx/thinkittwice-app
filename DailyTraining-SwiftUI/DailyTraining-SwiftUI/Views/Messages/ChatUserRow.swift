//
//  ChatUserRow.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/4/23.
//

import SwiftUI

struct ChatUserRow: View {
    var user: ChatUser
    
    var body: some View {
        HStack {
            Image(user.avatar)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .frame(height: 60)
            
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .minimumScaleFactor(0.3)
                Text(user.title)
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
            }
            
            Spacer()
            
            Image(systemName: "circle.fill")
                .foregroundColor(.accentColor)
                .font(.caption)
        }
    }
    
}

struct ChatUserRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatUserRow(user: MessagingUsersViewModel().users[0])
    }
}
