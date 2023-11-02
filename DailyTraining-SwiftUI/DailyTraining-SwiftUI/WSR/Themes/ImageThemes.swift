//
//  ImageThemes.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 11/1/23.
//

import Foundation

extension String {
    
    static func assets(_ value: Assets) -> String {
        return value.rawValue
    }
    
    enum Assets: String {
        
        //static var getLogo: Assets { return Config.shared.isPLS() ? .sg_logo : .my_logo }

        // common
        case sg_logo = "pls-logo"
        
    }
}


extension String {
    
    static func systemName(_ value: SystemName) -> String {
        return value.rawValue
    }
    
    enum SystemName: String {
        case xmark = "xmark"
        case exclamation_mark = "exclamationmark"
        case wifi_slash = "wifi.slash"
        case eye = "eye"
        case eye_slash = "eye.slash"
        case square_and_arrow_up = "square.and.arrow.up"
        case globe = "globe"
    }
}
