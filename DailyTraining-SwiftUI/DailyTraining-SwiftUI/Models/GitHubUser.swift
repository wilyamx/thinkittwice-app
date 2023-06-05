//
//  GitHubUser.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/5/23.
//

import Foundation

/**
 {
    "login": "octocat",
    "avatar_url": "https://github.com/images/error/octocat_happy.gif",
    "bio": "There once was...",
    "name": "monalisa octocat",
 }
 */
struct GitHubUser: Codable {
    let avatarUrl: String
    let login: String
    let bio: String
    let name: String
    
    static func placeholder() -> GitHubUser {
        return GitHubUser(avatarUrl: "https://avatars.githubusercontent.com/u/2200483?v=4",
                          login: "GITHUB USER",
                          bio: "Software Developer",
                          name: "GitHub User")
    }
    
    static func example() -> GitHubUser {
        return GitHubUser(avatarUrl: "https://avatars.githubusercontent.com/u/2200483?v=4",
                          login: "WILYAMX",
                          bio: "iOS Developer",
                          name: "William Rena")
    }
}
