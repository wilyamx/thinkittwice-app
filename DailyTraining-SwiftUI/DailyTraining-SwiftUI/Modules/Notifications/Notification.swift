//
//  Notification.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/19/23.
//

import Foundation

struct Notification: Decodable, Identifiable {
    let id: Int
    let title: String
    let description: String
}

extension Notification: Equatable {
    static func ==(lhs: Notification, rhs: Notification) -> Bool {
        return lhs.id == rhs.id
    }
}
