//
//  Helpers.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/4/23.
//

import Foundation

enum WSRDebugInfoKey: String {
    case realmDb = "[REALM-DB]>>"
    case messaging = "[MESSAGING]>>"
    case info = "[INFO]>>"
    case fileloader = "[FILE-LOADER]>>"
    case api = "[API]>>"
    case error = "[ERROR]>>"
    case cache = "[CACHE]>>"
}

struct WSRLogger {
    // this will filter what to log only
    // empty means accept all type of logs
    private let filteredLogKeys: [WSRDebugInfoKey] = []
    
    // MARK: - Deprecated
    
    /**
        Deprecated
     */
    func log(logKey: WSRDebugInfoKey, any: AnyObject, message: String) {
        guard filteredLogKeys.isEmpty ||
                (filteredLogKeys.count > 0 && filteredLogKeys.contains(logKey)) else {
            return
        }
        print("\(logKey.rawValue) [\(type(of: any))] :: \(message)")
    }
    
    /**
        Deprecated
     */
    func log(logKey: WSRDebugInfoKey = .info, category: String, message: String) {
        guard filteredLogKeys.isEmpty ||
                (filteredLogKeys.count > 0 && filteredLogKeys.contains(logKey)) else {
            return
        }
        print("\(logKey.rawValue) [\(category)] :: \(message)")
    }
    
    // MARK: - Private
    
    private func messageFormat(category: WSRDebugInfoKey,
                               message: String,
                               _ file: String,
                               _ function: String,
                               _ line: Int) {
        let filename = URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent
        print("\(category.rawValue) [\(filename).\(function):\(line)] - \(message)")
    }
    
    // MARK: - Public
    
    /**
        [INFO]>> [MessagingChatsView.body:27] - selected-item index: 3
     */
    func log(category: WSRDebugInfoKey,
             message: String,
             _ file: String = #file,
             _ function: String = #function,
             _ line: Int = #line) {
        self.messageFormat(category: category, message: message, file, function, line)
    }
    
    func info(message: String,
             _ file: String = #file,
             _ function: String = #function,
             _ line: Int = #line) {
        self.messageFormat(category: WSRDebugInfoKey.info, message: message, file, function, line)
    }
    
    func api(message: String,
             _ file: String = #file,
             _ function: String = #function,
             _ line: Int = #line) {
        self.messageFormat(category: WSRDebugInfoKey.api, message: message, file, function, line)
    }
    
    func error(message: String,
             _ file: String = #file,
             _ function: String = #function,
             _ line: Int = #line) {
        self.messageFormat(category: WSRDebugInfoKey.error, message: message, file, function, line)
    }
    
    // MARK: - Convenience
    
    func realmDB() {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path
        print("\(WSRDebugInfoKey.realmDb.rawValue) \(directory)")
    }
}

let logger = WSRLogger()
