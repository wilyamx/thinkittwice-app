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
}
