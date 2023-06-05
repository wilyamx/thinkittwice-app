//
//  WSRFetchers.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/11/23.
//

import Foundation

class WSRFetcher: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    var service: WSRApiServiceProtocol
    
    init(service: WSRApiServiceProtocol = WSRApiService()) {
       self.service = service
    }
    
    func requestStarted() {
        DispatchQueue.main.async {
            self.errorMessage = nil
            self.isLoading = true
        }
    }
    
    func requestFailed(reason: String) {
        DispatchQueue.main.async {
            self.errorMessage = reason
            self.isLoading = false
        }
    }
    
    func requestSuccess() {
        DispatchQueue.main.async {
            self.errorMessage = nil
            self.isLoading = false
        }
    }
}

