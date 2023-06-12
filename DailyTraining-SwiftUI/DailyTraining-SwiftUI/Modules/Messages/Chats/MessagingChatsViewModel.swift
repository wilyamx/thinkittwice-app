//
//  MessagingChatsViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/4/23.
//

import Foundation
import SwiftUI

final class MessagingChatsViewModel: WSRLocalFileLoader {
    @Published var list: [Chat] = [Chat]()
    @Published var selectedIndex:Int = 0
    
    @Published var searchText: String = ""
    
    override init(fileLoader: WSRFileLoader = WSRFileLoader()) {
        super.init(fileLoader: fileLoader)
    }
    
    func getList() {
        let filename = "MessagingChatsData.json"
        logger.log(category: .fileloader, message: "filename: \(filename)")
        
        self.fileLoader.loadJSON(
            "MessagingChatsData.json",
            [Chat].self,
            completion: { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        logger.error(message: "error message: \(error.description)")
                    case .success(let list):
                        logger.log(category: .fileloader, message: "total list: \(list.count)")
                        self?.list = list
                    }
                }
            })
    }
    
    func searchBy(key: String) {
        if key.isEmpty {
            list = []
            getList()
            logger.info(message: "All chats")
        }
        else {
            logger.info(message: "Search by: \(key)")
        }
        self.searchText = key
    }
}

struct Chat: Hashable, Codable, Identifiable {
    var id = UUID()
    var messageId: Int
    var title: String
    var message: String
    var avatar: String
    var unread: Int
    var type: Int
    
    init(messageId: Int,
         title: String,
         message: String,
         avatar: String,
         unread: Int,
         type: Int) {
        
        self.id = UUID()
        self.messageId = messageId
        self.title = title
        self.message = message
        self.avatar = avatar
        self.unread = unread
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
        case messageId
        case title
        case message
        case avatar
        case unread
        case type
    }
    
    static func example1() -> Chat {
        return Chat(messageId: 200,
                    title: "Tellus id interdum velit laoreet",
                    message: "Dis parturient montes nascetur ridiculus mus mauris vitae ultricies. Nec feugiat nisl pretium fusce id velit ut.",
                    avatar: "charleyrivers",
                    unread: 125,
                    type: 1)
    }
    
    static func example2() -> Chat {
        return Chat(messageId: 200,
                    title: "Tellus id interdum velit laoreet",
                    message: "Dis parturient montes nascetur ridiculus mus mauris vitae ultricies. Nec feugiat nisl pretium fusce id velit ut.",
                    avatar: "charleyrivers",
                    unread: 125,
                    type: 2)
    }
    
    static func example3() -> Chat {
        return Chat(messageId: 200,
                    title: "Tellus id interdum velit laoreet",
                    message: "Dis parturient montes nascetur ridiculus mus mauris vitae ultricies. Nec feugiat nisl pretium fusce id velit ut.",
                    avatar: "charleyrivers",
                    unread: 125,
                    type: 3)
    }
}
