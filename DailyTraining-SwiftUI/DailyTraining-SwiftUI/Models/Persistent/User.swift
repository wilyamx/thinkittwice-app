//
//  User.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/4/23.
//

import Foundation
import RealmSwift

class User: Object, Identifiable {
    @Persisted(primaryKey: false) var id: ObjectId
    @Persisted var email: String
    @Persisted var firstName: String
    @Persisted var lastName: String
    
    override class func primaryKey() -> String? {
        "email"
    }
}
