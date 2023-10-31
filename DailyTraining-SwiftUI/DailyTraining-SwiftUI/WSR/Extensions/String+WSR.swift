//
//  String+Extension.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/4/23.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

extension String {
    // Common
    static let empty = ""
    static let invalid_email = "Invalid email"
    static let invalid_password = "Invalid password"
    static let invalid_credentials = "Invalid Credentials"
    static let something_went_wrong = "Something went wrong!"
    static let invalid_registrations = "Invalid registration"
    static let registered_user = "Already registered user"
}
