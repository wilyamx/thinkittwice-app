//
//  MessagingUsersViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/4/23.
//

import Foundation

final class MessagingUsersViewModel: ObservableObject {
    @Published var users: [ChatUser] = load("MessagingUsersData.json")
}

struct ChatUser: Hashable, Codable, Identifiable {
    var id: Int
    var userId: Int
    var title: String
    var avatar: String
    var name: String
}
