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

struct Notification: Decodable, Identifiable {
    let id: Int
    let title: String
    let description: String
    
    static func example() -> Notification {
        return Notification(id: 1,
                            title: "Your financial report is overdue",
                            description: "Please submit your quarterly figures for Q2 by EOB on August 15")
    }
}
