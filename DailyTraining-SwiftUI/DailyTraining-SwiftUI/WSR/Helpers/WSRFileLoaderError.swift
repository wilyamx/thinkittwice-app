//
//  WSRFileLoaderError.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/11/23.
//

import Foundation

enum WSRFileLoaderError: Error, CustomStringConvertible {
    case fileNotFound(String)
    case fileCannotLoad(Error)
    case parsing(DecodingError?)
    case unknown
    
    var localizedDescription: String {
        // user feedback
        switch self {
        case .fileNotFound, .fileCannotLoad, .parsing, .unknown:
            return "Sorry, something went wrong."
        }
    }
    
    var description: String {
        //info for debugging
        switch self {
        case .unknown: return "Unknown Error"
        case .fileNotFound(let filePath): return "Invalid file path: \(filePath)"
        case .fileCannotLoad(let error): return "File cannot load: \(error)"
        case .parsing(let error):
            return "Parsing error \(error?.localizedDescription ?? "")"
        }
    }
}
