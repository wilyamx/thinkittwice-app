//
//  BreedFetcher.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/15/23.
//

import Foundation

final class BreedFetcher: WSRFetcher {
    @Published var breeds = [BreedModel]()
   
    override init(service: WSRApiServiceProtocol = WSRApiService()) {
        super.init(service: service)
        fetchAllBreeds()
    }
    
    func fetchAllBreeds() {
        self.isLoading = true
        self.errorMessage = nil
        
        service.getCatBreeds(
            urlString: "https://api.thecatapi.com/v1/breeds",
            completion: {
                [weak self] result in
                
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    switch result {
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    case .success(let breeds):
                        self?.breeds = breeds
                    }
                }
            })
    
    }
    
    // MARK: - Preview Helpers
       
    static func errorState() -> BreedFetcher {
       let fetcher = BreedFetcher()
       fetcher.errorMessage = WSRApiError.url(URLError.init(.notConnectedToInternet)).localizedDescription
       return fetcher
    }

    static func successState() -> BreedFetcher {
       let fetcher = BreedFetcher()
       fetcher.breeds = [BreedModel.example1(), BreedModel.example2()]
       
       return fetcher
    }
}
