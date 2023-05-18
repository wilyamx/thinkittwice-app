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
            completion: { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        logger.log(logKey: .error, category: "MessagingUsersViewModel", message: "errorMessage: \(error.description)")
                    case .success(let list):
                        logger.log(logKey: .info, category: "MessagingChatsViewModel", message: "total list: \(list.count)")
                        self?.list = list
                    }
                }
            })
    }
}

struct ChatUser: Hashable, Codable, Identifiable {
    var id = UUID()
    var userId: Int
    var title: String
    var avatar: String
    var name: String
    
    init(userId: Int,
         title: String,
         avatar: String,
         name: String) {
        
        self.id = UUID()
        self.userId = userId
        self.title = title
        self.avatar = avatar
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case userId
        case title
        case avatar
        case name
    }
    
    static func example() -> ChatUser {
        return ChatUser(userId: 2000,
                        title: "Tincidunt lobortis feugiat",
                        avatar: "turtlerock",
                        name: "Wiley McConway")
    }
}
