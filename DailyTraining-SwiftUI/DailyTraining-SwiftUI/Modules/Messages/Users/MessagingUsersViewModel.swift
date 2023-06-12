//
//  MessagingUsersViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/4/23.
//

import Foundation

final class MessagingUsersViewModel: ObservableObject {
    @Published var list: [ChatUser] = [ChatUser]()
    
    private let fileLoader: WSRFileLoader
    
    @Published var searchText: String = ""
    
    init(fileLoader: WSRFileLoader = WSRFileLoader()) {
        self.fileLoader = fileLoader
    }
    
    func getList() {
        let filename = "MessagingUsersData.json"
        logger.log(category: .fileloader, message: "filename: \(filename)")
        
        self.fileLoader.loadJSON(
            "MessagingUsersData.json",
            [ChatUser].self,
            completion: { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        logger.error(message: "errorMessage: \(error.description)")
                    case .success(let list):
                        
                        self?.list = list
                        logger.log(category: .fileloader, message: "total list: \(list.count)")
                    }
                }
            })
    }
    
    func searchBy(key: String) {
        if key.isEmpty {
            list = []
            getList()
            logger.info(message: "All users")
        }
        else {
            logger.info(message: "Search by: \(key)")
        }
        
        self.searchText = key
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
