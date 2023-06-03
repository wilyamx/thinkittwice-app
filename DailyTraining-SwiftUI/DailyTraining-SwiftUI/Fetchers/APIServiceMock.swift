//
//  APIServiceMock.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/16/23.
//

import Foundation

struct APIServiceMock: WSRApiServiceProtocol {
    var result: Result<[Breed], WSRApiError>

    func getCatBreeds(
        urlString: String,
        completion: @escaping(Result<[Breed], WSRApiError>) -> Void) {
            completion(result)
        }
}
