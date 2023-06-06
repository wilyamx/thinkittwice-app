//
//  Cat.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/6/23.
//

import RealmSwift

class Cat: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String
    
    @Persisted var name: String
    @Persisted var temperament: String
    @Persisted var breedExplanation: String
    @Persisted var energyLevel: Int
    @Persisted var isHairless: Bool
    
    override class func primaryKey() -> String? {
         "id"
    }
}
