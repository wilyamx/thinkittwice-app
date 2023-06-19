//
//  ChatUser.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/19/23.
//

import Foundation

struct ChatUser: Hashable, Codable, Identifiable {
    var id = UUID()
    var userId: Int
    var title: String
    var avatar: String
    var name: String
    
    init(userId: Int,
         title: String,
         avatar: String,
         name: String) {
        
        self.id = UUID()
        self.userId = userId
        self.title = title
        self.avatar = avatar
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case userId
        case title
        case avatar
        case name
    }

}
