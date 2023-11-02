//
//  WSRFetchers.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 11/2/23.
//

import Foundation
import SwiftUI

class WSRFetcher2: ObservableObject, WSRViewStateProtocol, WSRPersitableProtocol {
    @Published var viewState: WSRViewState = .empty
    @Published var showErrorAlert: Bool = false
    
    var loadingMessage: String = String.empty
    var errorMessage: String = String.empty
    var errorAlertType: WSRErrorAlertType = .none
    
    var service: WSRApiServiceProtocol
    
    init(service: WSRApiServiceProtocol = WSRApiService()) {
        self.service = service
    }
    
    // MARK: - WSRPersitableProtocol
    
    func persist() async {
        fatalError("Override this method and define your own implementation.")
    }
}

// MARK: - WSRViewStateProtocol

extension WSRFetcher2 {
    func requestStarted(message: String? = nil) {
        DispatchQueue.main.async {
            self.errorMessage = String.empty
            self.viewState = .loading
            
            if let message = message {
                self.loadingMessage = message
            }
        }
    }
    
    func requestFailed(reason: String, errorAlertType: WSRErrorAlertType = .none) {
        DispatchQueue.main.async {
            self.errorMessage = reason
            self.viewState = .error
            
            self.errorAlertType = errorAlertType
            if errorAlertType != .none {
                self.showErrorAlert = true
            }
        }
    }
    
    func requestSuccess() {
        DispatchQueue.main.async {
            self.errorMessage = String.empty
            self.viewState = .populated
            self.showErrorAlert = false
        }
    }
}
