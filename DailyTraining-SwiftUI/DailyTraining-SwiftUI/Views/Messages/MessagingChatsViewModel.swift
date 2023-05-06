//
//  MessagingChatsViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/4/23.
//

import Foundation
import SwiftUI

final class MessagingChatsViewModel: ObservableObject {
    @Published var chats: [Chat] = load("MessagingChatsData.json")
}

struct Chat: Hashable, Codable, Identifiable {
    //var id = UUID()
    var id: Int
    var messageId: Int
    var title: String
    var message: String
    var avatar: String
    var unread: Int
    var type: Int
}


