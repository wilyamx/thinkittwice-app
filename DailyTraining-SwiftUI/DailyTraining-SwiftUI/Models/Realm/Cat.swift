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
    //@Persisted var referenceImageId: String
    
    override class func primaryKey() -> String? {
         "id"
    }
    
    static func example() -> Cat {
        let cat = Cat()
        cat.id = "cypr"
        cat.name = "Cyprus"
        cat.temperament = "Affectionate, Social"
        cat.energyLevel = 4
        cat.isHairless = false
        cat.breedExplanation = "Loving, loyal, social and inquisitive, the Cyprus cat forms strong ties with their families and love nothing more than to be involved in everything that goes on in their surroundings. They are not overly active by nature which makes them the perfect companion for people who would like to share their homes with a laid-back relaxed feline companion."
        //cat.referenceImageId = "xnsqonbjW"
        
        return cat
    }
    
    static func referenceImageId1() -> String {
        return "xnsqonbjW"
    }
    
    static func referenceImageId2() -> String {
        return "0XYvRd7oD"
    }
}
