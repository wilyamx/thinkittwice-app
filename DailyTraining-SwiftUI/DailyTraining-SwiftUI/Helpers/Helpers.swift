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
}

func logger(logKey: DebugInfoKey, any: AnyObject, message: String) {
    print("\(logKey.rawValue) [\(type(of: any))] :: \(message)")
}

func logger(logKey: DebugInfoKey, category: String, message: String) {
    print("\(logKey.rawValue) [\(category)] :: \(message)")
}
