//
//  Chat.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/19/23.
//

import Foundation

struct Chat: Hashable, Codable, Identifiable {
    var id = UUID()
    var messageId: Int
    var title: String
    var message: String
    var avatar: String
    var unread: Int
    var type: Int
    
    init(messageId: Int,
         title: String,
         message: String,
         avatar: String,
         unread: Int,
         type: Int) {
        
        self.id = UUID()
        self.messageId = messageId
        self.title = title
        self.message = message
        self.avatar = avatar
        self.unread = unread
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
        case messageId
        case title
        case message
        case avatar
        case unread
        case type
    }
    
}
