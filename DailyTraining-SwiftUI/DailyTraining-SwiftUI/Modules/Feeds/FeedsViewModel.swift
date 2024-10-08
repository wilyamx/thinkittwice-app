//
//  FeedsViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/11/23.
//

import RealmSwift
import SwiftUI
import UIKit

final class FeedsViewModel: WSRFetcher2 {
    // request model
    @Published var breeds: [BreedModel] = [BreedModel]()
    
    // persisted data
    @ObservedResults(Cat.self) var cats
    @Environment(\.realm) var realm
    
    override init(service: WSRApiServiceProtocol = WSRApiService()) {
        super.init(service: service)
    }
    
    init(service: WSRApiServiceProtocol = WSRApiService(),
         mockData: Bool = false) {
        
        super.init(service: service)
        self.mockData = mockData
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
        
    public func initializeData(
        deletePersistedData: Bool = false,
        shuffle: Bool = false
    ) async {
        logger.info(message: "Initializing data...")
        
        requestStarted(message: String.initializing_data.localizedString())
        
        if deletePersistedData {
            cats.forEach { cat in
                try! realm.write {
                    realm.delete(cat)
                }
            }
            logger.info(message: "Deleted all persisted data!")
        }
        else {
            if cats.isEmpty {
                // do nothing
            }
            else {
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 1,
                    execute: {
                        self.requestSuccess()
                    })
                return
            }
        }
        
        // api request + parse + persist
        do {
            var list = [BreedModel]()
            
            if mockData {
                // using generics
                list = try await MockCatApiService().get([BreedModel].self,
                                                     path: CatApiEndpoints.breeds,
                                                     queryItems: nil)
            }
            else {
                // using generics
                list = try await CatApiService().get([BreedModel].self,
                                                     path: CatApiEndpoints.breeds,
                                                     queryItems: nil)
            }
            
            if shuffle {
                list.shuffle()
            }
            self.breeds = list
            
            await persist()
            
            self.requestSuccess()
            
            logger.info(message: "Request data and persist COMPLETE!")
        }
        catch(let error) {
            if let error = error as? WSRApiError {
                self.requestFailed(reason: error.localizedDescription)
                logger.error(message: error.localizedDescription)
            }
            else if let error = error as? URLError {
                if error.code == .notConnectedToInternet {
                    self.requestFailed(
                        reason: error.localizedDescription,
                        errorAlertType: .noInternetConnection
                    )
                }
                else {
                    self.requestFailed(
                        reason: error.localizedDescription,
                        errorAlertType: .somethingWentWrong
                    )
                }
            }
            
            logger.info(message: "Request data and persist ERROR!")
        }
    
    }
    
    public func deleteAllPersistedData() async {
        logger.info(message: "Deleting all persisted data...")
        
        requestStarted(message: String.resetting_data.localizedString())
        
        // delete persisted data
        cats.forEach { cat in
            try! realm.write {
                realm.delete(cat)
            }
        }
        
        // clear the json data
        breeds = []
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1,
            execute: {
                self.requestSuccess()
            })
        
        logger.info(message: "Deleting all persisted data... END")
    }
        
    // MARK: - Public Methods
    
    func fetchAllBreeds() {
        self.breeds = []
        
        self.requestStarted()
        
        let urlString = "https://api.thecatapi.com/v1/breeds"
        CatApiService().getCatBreeds(
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
