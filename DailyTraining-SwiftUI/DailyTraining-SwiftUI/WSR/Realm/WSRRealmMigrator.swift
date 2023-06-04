//
//  WSRRealmMigrator.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/4/23.
//

import Foundation
import RealmSwift

class WSRRealmMigrator {
    
    init() {
        updateSchema()
    }
    
    private func updateSchema() {
        let config = Realm.Configuration(schemaVersion: 1) { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                // add new fields here
                migration.enumerateObjects(ofType: User.className()) { oldObject, newObject in
                    newObject!["likes"] = 100
                }
            }
        }
        
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
    }
}
