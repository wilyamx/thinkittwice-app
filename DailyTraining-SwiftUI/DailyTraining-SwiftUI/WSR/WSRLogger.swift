//
//  Helpers.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/4/23.
//

import Foundation

enum WSRDebugInfoKey: String {
    case realmDb = "[REALMDB]>>"
    case messaging = "[MESSAGING]>>"
    case info = "[INFO]>>"
    case fileloader = "[FILELOADER]>>"
    case api = "[API]>>"
    case error = "[ERROR]>>"
    case cache = "[CACHE]>>"
}

struct WSRLogger {
    // this will filter what to log only
    // empty means accept all type of logs
    let filteredLogKeys: [WSRDebugInfoKey] = []
    
    func log(logKey: WSRDebugInfoKey, any: AnyObject, message: String) {
        guard filteredLogKeys.isEmpty ||
                (filteredLogKeys.count > 0 && filteredLogKeys.contains(logKey)) else {
            return
        }
        print("\(logKey.rawValue) [\(type(of: any))] :: \(message)")
    }
    
    func log(logKey: WSRDebugInfoKey = .info, category: String, message: String) {
        guard filteredLogKeys.isEmpty ||
                (filteredLogKeys.count > 0 && filteredLogKeys.contains(logKey)) else {
            return
        }
        print("\(logKey.rawValue) [\(category)] :: \(message)")
    }
}

let logger = WSRLogger()
