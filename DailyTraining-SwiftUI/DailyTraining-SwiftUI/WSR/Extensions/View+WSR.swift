//
//  View+Extension.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/4/23.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
        )
    }
}
#endif
