//
//  ChatMessageVM.swift
//  DailyTraining
//
//  Created by William Reña on 7/15/20.
//  Copyright © 2020 Andrew Daugdaug. All rights reserved.
//

import UIKit

class ChatMessageVM: NSObject {
    var name: String
    var photoUrl: String
    var userId: String
    var message: String
	var messageId: Int64
    var messageCreated: Int64
    var isShowDetails: Bool?
    var isEditable: Bool?
    var isFile: Bool?
	var fileName: String
    var fileUrl: String
    var fileType: String
    

    init(userId:String,
         name: String = "",
         photoUrl: String = "",
         message: String = "",
		 messageId: Int64 = 0,
         messageCreated: Int64 = 0,
         isShowDetails: Bool? = true,
		 isEditable: Bool? = false,
         isFile: Bool? = false,
		 fileName: String = "",
		 fileUrl: String = "",
         fileType: String = "") {
        
        self.userId = userId
        self.name = name
        self.photoUrl = photoUrl
        self.message = message
		self.messageId = messageId
        self.messageCreated = messageCreated
        self.isShowDetails = isShowDetails
		self.isEditable = isEditable

        self.isFile = isFile
		self.fileName = fileName
        self.fileUrl = fileUrl
        self.fileType = fileType
    }
}
