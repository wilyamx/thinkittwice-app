//
//  WSRApiServiceProtocol.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/16/23.
//

import Foundation

protocol WSRApiServiceProtocol {
    func getCatBreeds(
        urlString: String,
        completion: @escaping(Result<[Breed], WSRApiError>) -> Void)
}
