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
    case error = "[ERROR]>>"
    case cache = "[CACHE]>>"
    //
    case api = "[API]>>"
    case headers = "[HEADERS]>>"
    case request = "[REQUEST]>>"
    case body = "[BODY]>>"
    case response = "[RESPONSE]>>"
}

struct WSRLogger {
    // this will filter what to log only
    // empty means accept all type of logs
    private let filteredLogKeys: [WSRDebugInfoKey] = []
    
    private let nullString = "(null)"
    private let separatorString = "*******************************"
    
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
        guard filteredLogKeys.isEmpty ||
                (filteredLogKeys.count > 0 && filteredLogKeys.contains(category)) else {
            return
        }
        
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
    
    func realm(message: String,
             _ file: String = #file,
             _ function: String = #function,
             _ line: Int = #line) {
        self.messageFormat(category: WSRDebugInfoKey.realmDb, message: message, file, function, line)
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
    
    func request(request: URLRequest) {
        guard filteredLogKeys.isEmpty ||
                (filteredLogKeys.count > 0 && filteredLogKeys.contains(WSRDebugInfoKey.api)) else {
            return
        }
        
        let method = request.httpMethod!
        let url = request.url?.absoluteString ?? nullString
        let headers = prettyPrintedString(from: request.allHTTPHeaderFields) ?? nullString
        let body = string(from: request.httpBody, prettyPrint: true) ?? nullString
        
        print(separatorString)
        print("\(WSRDebugInfoKey.request.rawValue) \(method) \(url)")
        print("")
        print("\(WSRDebugInfoKey.headers.rawValue)\n\(headers)")
        print("")
        print("\(WSRDebugInfoKey.body.rawValue)\n\(body)")
    }
    
    func response(request: URLRequest, httpResponse: HTTPURLResponse, data: Data) {
        guard filteredLogKeys.isEmpty ||
                (filteredLogKeys.count > 0 && filteredLogKeys.contains(WSRDebugInfoKey.api)) else {
            return
        }
        
        // request
        let requestMethod = request.httpMethod ?? nullString
        let requestUrl = request.url?.absoluteString ?? nullString

        // response
        let responseStatusCode = httpResponse.statusCode
        let responseHeaders = prettyPrintedString(from: httpResponse.allHeaderFields) ?? nullString
        let responseData = string(from: data, prettyPrint: true) ?? nullString

        print(separatorString)
        print("\(WSRDebugInfoKey.response.rawValue) \(requestMethod) \(responseStatusCode) \(requestUrl)")
        print("")
        print("\(WSRDebugInfoKey.headers.rawValue)\n\(responseHeaders)")
        print("")
        print("\(WSRDebugInfoKey.body.rawValue)\n\(responseData)")
        print(separatorString)
    }
    
    // MARK: - Private Helpers
    
    private func string(from data: Data?, prettyPrint: Bool) -> String? {
        
        guard let data = data else {
            return nil
        }
        
        var response: String? = nil
        
        if prettyPrint,
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let prettyString = prettyPrintedString(from: json) {
            response = prettyString
        }
            
        else if let dataString = String.init(data: data, encoding: .utf8) {
            response = dataString
        }
        
        return response
    }
    
    private func prettyPrintedString(from json: Any?) -> String? {
        guard let json = json else {
            return nil
        }
        
        var response: String? = nil
        
        if let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
            let dataString = String.init(data: data, encoding: .utf8) {
            response = dataString
        }
        
        return response
    }
    
    // MARK: - Public Helpers
    
    func realmDB() {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path
        print("\(WSRDebugInfoKey.realmDb.rawValue) \(directory)")
    }
}

let logger = WSRLogger()
