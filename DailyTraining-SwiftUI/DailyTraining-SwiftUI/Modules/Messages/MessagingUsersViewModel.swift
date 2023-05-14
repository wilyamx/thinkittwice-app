//
//  MessagingUsersViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/4/23.
//

import Foundation

final class MessagingUsersViewModel: ObservableObject {
    @Published var list: [ChatUser] = [ChatUser]()
    
    private let fileLoader: FileLoader
    
    init(fileLoader: FileLoader = FileLoader()) {
        self.fileLoader = fileLoader
    }
    
    func getUsers() {
        self.fileLoader.loadJSON(
            "MessagingUsersData.json",
            [ChatUser].self,
            completion: { [unowned self] result in
                switch result {
                case .failure(let error):
                    logger(logKey: .info, category: "MessagingUsersViewModel", message: "errorMessage: \(error.localizedDescription)")
                case .success(let users):
                    self.list = users
                }
            })
    }
}

struct ChatUser: Hashable, Codable, Identifiable {
    var id: Int
    var userId: Int
    var title: String
    var avatar: String
    var name: String
    
    init(id: Int,
         userId: Int,
         title: String,
         avatar: String,
         name: String) {
        
        self.id = id
        self.userId = userId
        self.title = title
        self.avatar = avatar
        self.name = name
    }
    
    static func example() -> ChatUser {
        return ChatUser(id: 1000,
                        userId: 2000,
                        title: "Tincidunt lobortis feugiat",
                        avatar: "turtlerock",
                        name: "Wiley McConway")
    }
}
