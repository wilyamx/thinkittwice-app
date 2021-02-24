//
//  ChatChannelModel.swift
//  DailyTraining
//
//  Created by John Andrew Daugdaug on 7/1/20.
//  Copyright © 2020 Andrew Daugdaug. All rights reserved.
//

import Foundation

struct ChatChannelModel: Codable {
    var name: String?
    var time: UInt?
    var photo: String?
    var lastMsg: String?
    var type: UInt?
    var channelUrl: String?
    var isFrozen: Bool?
    var unreadMessageCount: UInt?
	var hasInactiveMember: Bool
    
    init(name: String? = "",
         time: UInt? = 0,
         photo: String? = "",
         lastMsg: String? = "",
         type: UInt? = 0,
         channelUrl: String? = "",
         isFrozen: Bool? = false,
         unreadMessageCount: UInt? = 0,
		 hasInactiveMember:Bool = false) {
        
        self.name = name
        self.time = time
        self.photo = photo
        self.lastMsg = lastMsg
        self.type = type
        self.channelUrl = channelUrl
        self.isFrozen = isFrozen
        self.unreadMessageCount = unreadMessageCount
		self.hasInactiveMember = hasInactiveMember
    }
}
