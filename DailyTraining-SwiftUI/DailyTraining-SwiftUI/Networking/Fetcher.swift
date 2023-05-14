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
    
    var service: APIService
    
    init(service: APIService = APIService()) {
       self.service = service
    }
    
    // MARK: - Preview Helpers
       
    static func errorState() -> BreedFetcher {
       let fetcher = BreedFetcher()
       fetcher.errorMessage = APIError.url(URLError.init(.notConnectedToInternet)).localizedDescription
       return fetcher
    }

    static func successState() -> BreedFetcher {
       let fetcher = BreedFetcher()
       fetcher.breeds = [Breed.example1(), Breed.example2()]
       
       return fetcher
    }
}

