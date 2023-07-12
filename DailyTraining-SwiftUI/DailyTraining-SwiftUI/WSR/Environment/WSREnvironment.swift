//
//  WSREnvironment.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 7/12/23.
//
// https://www.danijelavrzan.com/posts/2022/11/xcode-configuration/#:~:text=Xcode%20build%20configuration%20files%20or,Bool%20%2C%20or%20other%20defined%20formats.

import Foundation

public struct WSREnvironment {
    public enum WSRKeys {
        static let baseURL = "BASE_URL"
    }
    
    // Get the BASE_URL
    static let baseURL: String = {
        return "https://api.thecatapi.com"
        
        guard let baseURLProperty = Bundle.main.object(forInfoDictionaryKey: WSRKeys.baseURL) as? String else {
            fatalError("BASE_URL not found")
        }
        return baseURLProperty
    }()
    
    static let catBaseURL: String = "https://api.thecatapi.com"
    static let gitHubBaseURL: String = "https://api.github.com"
}
