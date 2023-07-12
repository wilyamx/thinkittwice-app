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
    
    override func persist() async {
        breeds.forEach { model in
            let cat = Cat()
            cat.id = model.id
            cat.name = model.name
            cat.temperament = model.temperament
            
            cat.energyLevel = model.energy_level
            //cat.isHairless = model.hairless
            cat.breedExplanation = model.description
            cat.referenceImageId = model.reference_image_id ?? "Reference image id"
            cat.altNames = model.alt_names ?? "Alternative names"
            
            $cats.append(cat)
        }
    }
        
    func initializeData(deletePersistedData: Bool = false) async {
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
                return
            }
        }
        
        // api request + parse + persist
        do {
            breeds = try await CatApiService().get([BreedModel].self,
                                                   path: "/v1/breeds",
                                                   queryItems: nil)
            await persist()
            
            self.requestSuccess()
            
            logger.info(message: "Request data and persist COMPLETE!")
        }
        catch(let error) {
            if let error = error as? WSRApiError {
                logger.error(message: error.localizedDescription)
            }
            self.requestFailed(reason: error.localizedDescription)
            
            logger.info(message: "Request data and persist ERROR!")
        }
    
    }
    
    func deleteAllPersistedData() async {
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
    }
        
    // MARK: - Public Methods
    
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
    
    // MARK: - Logs
    
    func printAllBreeds() {
        for (index, breed) in self.breeds.enumerated() {
            logger.api(message: "[BreedModel\(index)]: \(breed)")
        }
    }
}
