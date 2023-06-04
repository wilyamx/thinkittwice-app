//
//  DailyTraining_SwiftUIApp.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

@main
struct DailyTraining_SwiftUIApp: App {
    
    let realmMigrator = WSRRealmMigrator()
    
    var body: some Scene {
        WindowGroup {
            let _ = UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            let _ = logger.realmDB()
            ContentView()
                .environmentObject(ProfileViewModel())
        }
    }
}
