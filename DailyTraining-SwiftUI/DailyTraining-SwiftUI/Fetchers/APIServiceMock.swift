//
//  APIServiceMock.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/16/23.
//

import Foundation

struct APIServiceMock: WSRApiServiceProtocol {
    static func getURLSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        return configuration
    }
    
    func get<T>(_ type: T.Type,
                path: String,
                queryItems: [URLQueryItem]?) async throws -> T where T : Decodable {
        return BreedModel.example1() as! T
    }
    
    func post(path: String, bodyParam: String) { }
    
    func put(path: String, bodyParam: String) { }
    
    func delete(path: String, bodyParam: String) { }
    
    
    
    var result: Result<[BreedModel], WSRApiError>

    func getCatBreeds(
        urlString: String,
        completion: @escaping(Result<[BreedModel], WSRApiError>) -> Void) {
            completion(result)
        }
}
