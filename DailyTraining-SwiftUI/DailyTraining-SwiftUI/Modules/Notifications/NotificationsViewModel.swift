//
//  NotificationsViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/5/23.
//

import Foundation

final class NotificationsViewModel: WSRLocalFileLoader {
    @Published var list: [Notification] = [Notification]()
    
    override init(fileLoader: WSRFileLoader = WSRFileLoader()) {
        super.init(fileLoader: fileLoader)
    }
    
    func getList() {
        let filename = "NotificationsData.json"
        logger.log(category: .fileloader, message: "filename: \(filename)")
        
        self.fileLoader.loadJSON(
            filename,
            [Notification].self,
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
}
