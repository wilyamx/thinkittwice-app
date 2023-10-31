//
//  WSRFetchers.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/11/23.
//

import Foundation

class WSRFetcher2: ObservableObject, WSRViewStateProtocol {
    @Published var viewState: WSRViewState = .empty
    var loadingMessage: String = String.empty
    var errorMessage: String = String.empty
    
    var service: WSRApiServiceProtocol
    
    init(service: WSRApiServiceProtocol = WSRApiService()) {
        self.service = service
    }
    
    func requestStarted(message: String? = nil) {
        DispatchQueue.main.async {
            self.errorMessage = String.empty
            self.viewState = .loading
            
            if let message = message {
                self.loadingMessage = message
            }
        }
    }
    
    func requestFailed(reason: String) {
        DispatchQueue.main.async {
            self.errorMessage = reason
            self.viewState = .error
        }
    }
    
    func requestSuccess() {
        DispatchQueue.main.async {
            self.errorMessage = String.empty
            self.viewState = .populated
        }
    }
    
    func persist() async {
        fatalError("Override this method and define your own implementation.")
    }
}

