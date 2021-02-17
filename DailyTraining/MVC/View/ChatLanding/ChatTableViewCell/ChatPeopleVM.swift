//
//  ChatPeopleVM.swift
//  DailyTraining
//
//  Created by John Andrew Daugdaug on 7/2/20.
//  Copyright © 2020 Andrew Daugdaug. All rights reserved.
//

import Foundation

class ChatPeopleVM: NSObject {
    var name: String
    var photoUrl: String
    var position: String
    var status: Bool
    var userId: String
    
    // for multiple selection
    var isSelected: Bool
    
    init(userId:String,
         name: String = "",
         photoUrl: String = "",
         position: String = "",
         status: Bool = false,
         isSelected: Bool = false) {
        
        self.userId = userId
        self.name = name
        self.photoUrl = photoUrl
        self.position = position
        self.status = status
        self.isSelected = isSelected
    }
}
