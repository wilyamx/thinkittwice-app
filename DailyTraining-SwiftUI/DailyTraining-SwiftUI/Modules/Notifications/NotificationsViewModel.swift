//
//  NotificationsViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/5/23.
//

import Foundation

final class NotificationsViewModel: LocalFileLoader {
    @Published var list: [Notification] = [Notification]()
    
    override init(fileLoader: FileLoader = FileLoader()) {
        super.init(fileLoader: fileLoader)
    }
    
    func getList() {
        self.fileLoader.loadJSON(
            "NotificationsData.json",
            [Notification].self,
            completion: { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        logger.log(logKey: .error, category: "NotificationsViewModel", message: "error message: \(error.description)")
                    case .success(let list):
                        logger.log(logKey: .info, category: "NotificationsViewModel", message: "total list: \(list.count)")
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
