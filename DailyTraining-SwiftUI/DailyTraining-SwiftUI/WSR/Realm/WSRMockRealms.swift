//
//  WSRMockRealms.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/12/23.
//

import RealmSwift

class WSRMockRealms {
    static var config: Realm.Configuration {
        WSRMockRealms.previewRealm.configuration
    }
    
   static var previewRealm: Realm = {
         var realm: Realm
         let identifier = "previewRealm"
         let config = Realm.Configuration(inMemoryIdentifier: identifier)
         do {
            realm = try Realm(configuration: config)
            try realm.write {
                let model = BreedModel.bombayCat()
                
                let cat = Cat()
                cat.id = model.id
                cat.name = model.name
                cat.temperament = model.temperament
                cat.energyLevel = model.energy_level
                cat.breedExplanation = model.description
                cat.referenceImageId = model.reference_image_id ?? "Reference image id"
                cat.altNames = model.alt_names ?? "Alternative names"
                
                realm.add(cat)
            }
             
            return realm
         } catch let error {
            fatalError("Error: \(error.localizedDescription)")
         }
   }()
}
