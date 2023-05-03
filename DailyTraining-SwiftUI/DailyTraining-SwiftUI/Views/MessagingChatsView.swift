//
//  MessagingChatsView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct MessagingChatsView: View {
    var body: some View {
        ZStack {
            Color.yellow
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(.green)
            Text("Chats")
                .foregroundColor(.white)
                .font(.system(size: 70))
        }
    }
}

struct MessagingChatsView_Previews: PreviewProvider {
    static var previews: some View {
        MessagingChatsView()
    }
}
