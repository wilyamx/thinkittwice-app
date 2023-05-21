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
    @Published var selectedIndex:Int = 0
    
    private let fileLoader: FileLoader
    
    init(fileLoader: FileLoader = FileLoader()) {
        self.fileLoader = fileLoader
    }
    
    func getChats() {
        self.fileLoader.loadJSON(
            "MessagingChatsData.json",
            [Chat].self,
            completion: { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        logger.log(logKey: .error, category: "MessagingChatsViewModel", message: "error message: \(error.description)")
                    case .success(let list):
                        logger.log(logKey: .info, category: "MessagingChatsViewModel", message: "total list: \(list.count)")
                        self?.list = list
                    }
                }
            })
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
    
    static func example() -> Chat {
        return Chat( messageId: 200,
                    title: "Tellus id interdum velit laoreet",
                    message: "Dis parturient montes nascetur ridiculus mus mauris vitae ultricies. Nec feugiat nisl pretium fusce id velit ut.",
                    avatar: "charleyrivers",
                    unread: 125,
                    type: 3)
    }
    
}
