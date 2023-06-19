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
