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
}

