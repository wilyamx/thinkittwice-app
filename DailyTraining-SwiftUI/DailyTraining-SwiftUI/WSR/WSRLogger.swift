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
    private let filteredLogKeys: [WSRDebugInfoKey] = []
    
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
    
    private func messageFormat(category: WSRDebugInfoKey,
                               message: String,
                               _ filename: String,
                               _ function: String,
                               _ line: Int) {
        print("\(category.rawValue) [\(filename).\(function):\(line)] - \(message)")
    }
    /**
        [INFO]>> [MessagingChatsView.body:27] - selected-item index: 3
     */
    func log(category: WSRDebugInfoKey,
             message: String,
             _ file: String = #file,
             _ function: String = #function,
             _ line: Int = #line) {
        let filename = URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent
        self.messageFormat(category: category, message: message, filename, function, line)
    }
    
    func info(message: String,
             _ file: String = #file,
             _ function: String = #function,
             _ line: Int = #line) {
        let filename = URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent
        self.messageFormat(category: WSRDebugInfoKey.info, message: message, filename, function, line)
    }
    
    func api(message: String,
             _ file: String = #file,
             _ function: String = #function,
             _ line: Int = #line) {
        let filename = URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent
        self.messageFormat(category: WSRDebugInfoKey.api, message: message, filename, function, line)
    }
    
    func error(message: String,
             _ file: String = #file,
             _ function: String = #function,
             _ line: Int = #line) {
        let filename = URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent
        self.messageFormat(category: WSRDebugInfoKey.error, message: message, filename, function, line)
    }
}

let logger = WSRLogger()
