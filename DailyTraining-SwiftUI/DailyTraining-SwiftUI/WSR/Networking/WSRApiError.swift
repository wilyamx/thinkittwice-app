//
//  WSRApiError.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/11/23.
//
// https://www.django-rest-framework.org/api-guide/status-codes/

import Foundation

enum WSRApiError: Error, CustomStringConvertible {
    case badURL
    case badResponse(statusCode: Int)
    case badRequest
    case url(URLError?)
    case parsing(DecodingError?)
    case serverError
    case unknown
    
    var localizedDescription: String {
        // user feedback
        switch self {
        case .badURL, .parsing, .serverError, .unknown:
            return "Sorry, something went wrong."
        case .badRequest:
            return "Sorry, client error!"
        case .badResponse(_):
            return "Sorry, the connection to our server failed."
        case .url(let error):
            return error?.localizedDescription ?? "Something went wrong."
        }
    }
    
    var description: String {
        //info for debugging
        switch self {
        case .serverError, .unknown: return "Unknown Error"
        case .badURL: return "Invalid URL"
        case .url(let error):
            return error?.localizedDescription ?? "URL Session Error"
        case .parsing(let error):
            return "Parsing error \(error?.localizedDescription ?? "")"
        case .badResponse(statusCode: let statusCode):
            return "Bad response with status code \(statusCode)"
        case .badRequest:
            return "Client error"
        }
    }
}
