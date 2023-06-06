//
//  APIServiceMock.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/16/23.
//

import Foundation

struct APIServiceMock: WSRApiServiceProtocol {
    var result: Result<[BreedModel], WSRApiError>

    func getCatBreeds(
        urlString: String,
        completion: @escaping(Result<[BreedModel], WSRApiError>) -> Void) {
            completion(result)
        }
}
