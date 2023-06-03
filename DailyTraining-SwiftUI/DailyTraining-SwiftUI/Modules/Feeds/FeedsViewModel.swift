//
//  FeedsViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/11/23.
//

import Foundation
import SwiftUI

final class FeedsViewModel: WSRFetcher {
    @Published var breeds: [Breed] = [Breed]()
    
    override init(service: WSRApiServiceProtocol = WSRApiService()) {
        super.init(service: service)
    }
    
    func fetchAllBreeds() {
        self.isLoading = true
        self.errorMessage = nil
        self.breeds = []
        
        let urlString = "https://api.thecatapi.com/v1/breeds"
        service.getCatBreeds(
            urlString: urlString,
            completion: { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    case .success(let breeds):
                        logger.api(message: "list count: \(breeds.count)")
                        
                        self?.isLoading = false
                        self?.breeds = breeds
                    }
                }
            })

    }
    
    func printAllBreeds() {
        for (index, breed) in self.breeds.enumerated() {
            logger.api(message: "Breed[\(index)]: \(breed)")
        }
    }
}
