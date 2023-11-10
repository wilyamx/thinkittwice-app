//
//  WSRConstants.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 10/31/23.
//

import Foundation
import SwiftUI

enum WSRViewState {
    // processing
    case loading
    // completed
    case populated
    // empty view
    case empty
    // error message display
    case error
}

enum WSRUserDefaultsKey: String, CaseIterable {
    case email = "WSR_Email"
    case isLoggedOut = "WSR_IsLoggedOut"
}

enum WSRErrorAlertType: Equatable {
    case somethingWentWrong
    case connectionTimedOut
    case noInternetConnection
    case badRequest
    case domain
    case none
    case custom(String)
    
    func getIconSystemName() -> String {
        switch self {
        case .somethingWentWrong,
                .badRequest,
                .connectionTimedOut,
                .domain:
            return "exclamationmark"
        case .noInternetConnection: return "wifi.slash"
        case .none: return "checkmark"
        case .custom(_): return "person.fill.questionmark"
        }
    }
    
    func getTitle() -> String {
        switch self {
        case .somethingWentWrong: return "Something Went Wrong"
        case .badRequest: return "Bad Request"
        case .connectionTimedOut: return "Connection Timed Out"
        case .noInternetConnection: return "No Internet Connection"
        case .domain: return "Domain Connection"
        case .none: return "Works well"
        case .custom(_): return "Custom Error"
        }
    }
    
    func getMessage() -> String {
        switch self {
        case .somethingWentWrong: return "Sorry, an error occured while trying to sign in.\nPlease try again later."
        case .connectionTimedOut: return "Sorry, connection timeout.\nPlease try again later."
        case .noInternetConnection: return "Please try again when your connection is available."
            
        case .badRequest: return "Sorry, bad request."
        case .domain: return "Could not connect to the server."
        case .none: return "Work as expected."
        case .custom(let message): return message
        }
    }
    
    func getActionButtonText() -> String {
        switch self {
        case .somethingWentWrong,
                .badRequest,
                .connectionTimedOut,
                .noInternetConnection,
                .domain,
                .none,
                .custom(_):
            return "Got it"
        }
    }
}
