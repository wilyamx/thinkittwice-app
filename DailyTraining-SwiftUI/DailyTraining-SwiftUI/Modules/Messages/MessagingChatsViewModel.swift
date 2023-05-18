//
//  MessagingChatsViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/4/23.
//

import Foundation
import SwiftUI

final class MessagingChatsViewModel: ObservableObject {
    @Published var list: [Chat] = [Chat]()
    
    private let fileLoader: FileLoader
    
    init(fileLoader: FileLoader = FileLoader()) {
        self.fileLoader = fileLoader
    }
    
    func getChats() {
        self.fileLoader.loadJSON(
            "MessagingChatsData.json",
            [Chat].self,
            completion: { [unowned self] result in
                switch result {
                case .failure(let error):
                    logger.log(logKey: .info, category: "MessagingChatsViewModel", message: "error message: \(error.localizedDescription)")
                case .success(let chats):
                    logger.log(logKey: .info, category: "MessagingChatsViewModel", message: "total chats: \(chats.count)")
                    self.list = chats
                }
            })
    }
}

struct Chat: Hashable, Codable, Identifiable {
    //var id = UUID(){}
    var id: Int
    var messageId: Int
    var title: String
    var message: String
    var avatar: String
    var unread: Int
    var type: Int
    
    init(id: Int,
         messageId: Int,
         title: String,
         message: String,
         avatar: String,
         unread: Int,
         type: Int) {
        
        self.id = id
        self.messageId = messageId
        self.title = title
        self.message = message
        self.avatar = avatar
        self.unread = unread
        self.type = type
    }
    
    static func example() -> Chat {
        return Chat(id: 100,
                    messageId: 200,
                    title: "Tellus id interdum velit laoreet",
                    message: "Dis parturient montes nascetur ridiculus mus mauris vitae ultricies. Nec feugiat nisl pretium fusce id velit ut.",
                    avatar: "charleyrivers",
                    unread: 125,
                    type: 3)
    }
    
}
