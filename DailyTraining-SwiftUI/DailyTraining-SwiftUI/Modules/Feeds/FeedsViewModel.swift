//
//  FeedsViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/11/23.
//

import RealmSwift
import SwiftUI

final class FeedsViewModel: WSRFetcher {
    // request model
    @Published var breeds: [BreedModel] = [BreedModel]()
    
    // persisted data
    @ObservedResults(Cat.self) var cats
    @Environment(\.realm) var realm
    
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
    
    override func persist() async -> Bool {
        breeds.forEach { model in
            let cat = Cat()
            cat.id = model.id ?? "id"
            cat.name = model.name ?? "Name"
            cat.temperament = model.temperament ?? "Temperament"
            cat.energyLevel = model.energyLevel ?? 0
            cat.isHairless = model.isHairless ?? false
            cat.breedExplanation = model.breedExplaination ?? "Breed Explaination"
            
            $cats.append(cat)
        }
        return true
    }
        
    
    func initializeData(deletePersistedData: Bool = false) async -> Bool {
        logger.info(message: "Initializing data...")
        
        self.requestStarted()
        
        if deletePersistedData {
            cats.forEach { cat in
                try! realm.write {
                    realm.delete(cat)
                }
            }
            logger.info(message: "Deleted all persisted data!")
        }
        else {
            if !cats.isEmpty {
                return false
            }
        }
        
        // api request + parse + persist
        do {
            breeds = try await WSRApiService().getCatBreeds(urlString: "https://api.thecatapi.com/v1/breeds")
            let _ = await persist()
            
            self.requestSuccess()
            
            logger.info(message: "Request data and persist COMPLETE!")
            return true
        }
        catch(let error) {
            logger.error(message: "Error! \(error.localizedDescription)")
            self.requestFailed(reason: error.localizedDescription)
            
            logger.info(message: "Request data and persist ERROR!")
            return false
        }
    
    }
    
    func deleteAllPersistedData() async -> Bool {
        logger.info(message: "Deleting all persisted data...")
        
        self.requestStarted()
        
        // delete persisted data
        cats.forEach { cat in
            try! realm.write {
                realm.delete(cat)
            }
        }
        
        // clear the json data
        breeds = []
        
        logger.info(message: "Deleting all persisted data... END")
        return true
    }
        
    // MARK: - Logs
    
    func printAllBreeds() {
        for (index, breed) in self.breeds.enumerated() {
            logger.api(message: "Breed[\(index)]: \(breed)")
        }
    }
}
