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
}
