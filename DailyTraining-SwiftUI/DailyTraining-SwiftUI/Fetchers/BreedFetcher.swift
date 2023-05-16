//
//  BreedFetcher.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/15/23.
//

import Foundation

final class BreedFetcher: Fetcher {
    @Published var breeds = [Breed]()
   
    override init(service: APIServiceProtocol = APIService()) {
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
                        self?.isLoading = false
                    }
                }
            })
    
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
