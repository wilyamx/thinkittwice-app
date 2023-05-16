//
//  APIServiceProtocol.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/16/23.
//

import Foundation

protocol APIServiceProtocol {
    func getCatBreeds(
        urlString: String,
        completion: @escaping(Result<[Breed], APIError>) -> Void)
}
