//
//  FeedsViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/11/23.
//

import Foundation
import SwiftUI

final class FeedsViewModel: WSRFetcher {
    @Published var breeds: [BreedModel] = [BreedModel]()
    
    override init(service: WSRApiServiceProtocol = WSRApiService()) {
        super.init(service: service)
    }
    
    func fetchAllBreeds() {
        self.breeds = []
        
        self.requestStarted()
        
        let urlString = "https://api.thecatapi.com/v1/breeds"
        service.getCatBreeds(
            urlString: urlString,
            completion: { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                        
                    case .failure(let error):
                        logger.error(message: error.localizedDescription)
                        self?.requestFailed(reason: error.localizedDescription)
                        
                    case .success(let breeds):
                        logger.api(message: "list count: \(breeds.count)")
                        
                        self?.breeds = breeds
                        self?.requestSuccess()
                    }
                }
            })

    }
    
    func getCats() async {
        var cats: [BreedModel] = []
        
        self.requestStarted()
        
        do {
            cats = try await WSRApiService().getCatBreeds(urlString: "https://api.thecatapi.com/v1/breeds")
            
            self.requestSuccess()
        }
        catch(let error) {
            logger.error(message: "Error! \(error.localizedDescription)")
            self.requestFailed(reason: error.localizedDescription)
        }
    }
    
    func printAllBreeds() {
        for (index, breed) in self.breeds.enumerated() {
            logger.api(message: "Breed[\(index)]: \(breed)")
        }
    }
}
