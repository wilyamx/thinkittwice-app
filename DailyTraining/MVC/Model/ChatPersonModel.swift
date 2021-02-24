//
//  ChatPersonModel.swift
//  DailyTraining
//
//  Created by John Andrew Daugdaug on 7/2/20.
//  Copyright © 2020 Andrew Daugdaug. All rights reserved.
//

import Foundation

struct ChatPersonModel: Codable {
    var name: String?
    var position: String?
    var connectionStatus: Bool?
    var photoUrl: String?
    var userId: String?
    
    init(userId:String,
         name: String? = "",
         position: String? = "",
         connectionStatus: Bool? = false,
         photoUrl: String? = "") {
        self.userId = userId
        self.name = name
        self.position = position
        self.connectionStatus = connectionStatus
        self.photoUrl = photoUrl
    }
}
