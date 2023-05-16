//
//  APIServiceMock.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/16/23.
//

import Foundation

struct APIServiceMock: APIServiceProtocol {
    var result: Result<[Breed], APIError>

    func getCatBreeds(
        urlString: String,
        completion: @escaping(Result<[Breed], APIError>) -> Void) {
            completion(result)
        }
}
