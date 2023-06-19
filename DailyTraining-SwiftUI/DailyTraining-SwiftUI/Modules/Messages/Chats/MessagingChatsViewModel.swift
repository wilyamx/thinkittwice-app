//
//  MessagingChatsViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/4/23.
//

import Foundation

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
