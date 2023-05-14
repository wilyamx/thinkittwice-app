//
//  Fetcher+Extension.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/15/23.
//

import Foundation

final class BreedFetcher: Fetcher {
    @Published var breeds = [Breed]()
   
    override init(service: APIService = APIService()) {
        super.init()
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
                        // print(error.description)
                        print(error)
                    case .success(let breeds):
                        print("--- sucess with \(breeds.count)")
                        self?.breeds = breeds
                        self?.isLoading = false
                    }
                }
            })
    
    }
    
    
}
