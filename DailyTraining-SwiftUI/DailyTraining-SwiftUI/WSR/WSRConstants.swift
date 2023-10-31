//
//  WSRConstants.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 10/31/23.
//

import Foundation

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
