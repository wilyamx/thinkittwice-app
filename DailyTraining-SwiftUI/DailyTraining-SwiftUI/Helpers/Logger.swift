//
//  Helpers.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/4/23.
//

import Foundation

enum DebugInfoKey: String {
    case realmDb = "[REALMDB]>>"
    case messaging = "[MESSAGING]>>"
    case info = "[INFO]>>"
    case fileloader = "[FILELOADER]>>"
    case api = "[API]>>"
    case error = "[ERROR]>>"
    case cache = "[CACHE]>>"
}

struct Logger {
    // this will filter what to log only
    let interestedLogKeys: [DebugInfoKey] = []
    
    func log(logKey: DebugInfoKey, any: AnyObject, message: String) {
        guard interestedLogKeys.isEmpty ||
                (interestedLogKeys.count > 0 && interestedLogKeys.contains(logKey)) else {
            return
        }
        print("\(logKey.rawValue) [\(type(of: any))] :: \(message)")
    }
    
    func log(logKey: DebugInfoKey = .info, category: String, message: String) {
        guard interestedLogKeys.isEmpty ||
                (interestedLogKeys.count > 0 && interestedLogKeys.contains(logKey)) else {
            return
        }
        print("\(logKey.rawValue) [\(category)] :: \(message)")
    }
}

let logger = Logger()
