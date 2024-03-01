//
//  MockGitHubApiService.swift
//  DailyTraining-SwiftUI
//
//  Created by William S. Rena on 3/1/24.
//  Copyright © 2024 Training Project. All rights reserved.
//

import Foundation

struct MockGitHubApiService: WSRApiServiceProtocol {
    
    static func getURLSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        return configuration
    }
    
    func get<T>(_ type: T.Type,
                path: String,
                queryItems: [URLQueryItem]?) async throws -> T where T : Decodable {
        
        if let path = Bundle.main.url(
            forResource: "GithubUser",
            withExtension: ".json") {
            do {
                let data = try Data(contentsOf: path)
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                return try decoder.decode(GitHubUser.self, from: data) as! T
            } catch {
                throw WSRApiError.parsing(error as? DecodingError)
            }
        }
        else {
            throw WSRApiError.badURL
        }
    }
    
    func post(path: String, bodyParam: String) {
        
    }
    
    func put(path: String, bodyParam: String) {
        
    }
    
    func delete(path: String, bodyParam: String) {
        
    }
    
    
}
