//
//  ChatMessageModel.swift
//  DailyTraining
//
//  Created by William Reña on 7/17/20.
//  Copyright © 2020 Andrew Daugdaug. All rights reserved.
//

import Foundation

struct ChatMessageModel: Codable {
    var message: String
	var messageId: Int64
    var createdAt: Int64
    var photoUrl: String?
    var senderName: String?
    var senderUserId: String?
    var isFile: Bool?
	var fileName: String?
    var fileUrl: String?
    var fileType: String?
    

    init(message: String,
		 messageId: Int64,
         createdAt: Int64,
         photoUrl: String? = "",
         senderName: String? = "",
         senderUserId: String? = "",
         isFile: Bool? = false,
		 fileName: String = "",
         fileUrl: String = "",
         fileType: String = "") {
        
        self.message = message
		self.messageId = messageId
        self.createdAt = createdAt
        self.photoUrl = photoUrl
        self.senderName = senderName
        self.senderUserId = senderUserId
        self.isFile = isFile
		self.fileName = fileName
        self.fileUrl = fileUrl
        self.fileType = fileType
    }
}
