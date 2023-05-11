//
//  FeedsViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/11/23.
//

import Foundation
import SwiftUI

final class FeedsViewModel: ObservableObject {
    @Published var breeds: [Breed] = [Breed]()
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let service: APIService
    
    init(service: APIService = APIService()) {
        self.service = service
    }
    
    func fetchAllBreeds() {
        let urlString = "https://api.thecatapi.com/v1/breeds"
        
        self.service.fetch(
            [Breed].self,
            urlString: urlString,
            completion: { [unowned self] result in
                switch result {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("[DebugMode] [FeedsViewModel] errorMessage: \(self.errorMessage ?? "")")
                case .success(let breeds):
                    self.breeds = breeds
                }
            })
        
//        self.service.getCatBreeds(
//            urlString: urlString,
//            completion: { [unowned self]
//                result in
//                switch result {
//                case .failure(let error):
//                    self.errorMessage = error.localizedDescription
//                    print("[DebugMode] [FeedsViewModel] errorMessage: \(self.errorMessage ?? "")")
//                case .success(let breeds):
//                    self.breeds = breeds
//                    print("[DebugMode] [FeedsViewModel] breeds: \(breeds)")
//                }
//            })
        
    }
}
