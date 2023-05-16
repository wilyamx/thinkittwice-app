//
//  Fetchers.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/11/23.
//

import Foundation

class Fetcher: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    var service: APIServiceProtocol
    
    init(service: APIServiceProtocol = APIService()) {
       self.service = service
    }
}

