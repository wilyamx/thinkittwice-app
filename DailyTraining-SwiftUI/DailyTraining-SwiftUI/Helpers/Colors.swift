//
//  Colors.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/21/23.
//

import SwiftUI

enum ColorNames: String {
    case listBackgroundColor = "ListBackgroundColor"
    case accentColor = "AccentColor"
    
    var colorValue: Color {
        return Color(self.rawValue)
    }
}
