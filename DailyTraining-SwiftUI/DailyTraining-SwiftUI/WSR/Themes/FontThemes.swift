//
//  FontThemes.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 11/1/23.
//

import Foundation

extension String {
    
    static func font(_ value: Font) -> String {
        return value.rawValue
    }
    
    enum Font: String {
        
        //static var getFont: Font { return Config.shared.isPLS() ? .arial : .avenir }

        case arial = "Arial"
        case avenir = "Avenir"
        case arial_BoldMT = "Arial-BoldMT"
    }
}
