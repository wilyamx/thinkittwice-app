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
                    logger(logKey: .info, category: "MessagingChatsViewModel", message: "errorMessage: \(error.localizedDescription)")
                case .success(let chats):
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
}


