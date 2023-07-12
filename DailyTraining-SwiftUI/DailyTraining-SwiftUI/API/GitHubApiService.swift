//
//  GitHubApiService.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 7/13/23.
//

import Foundation

struct GitHubApiService: WSRApiServiceProtocol {
    
    static func getURLSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        return configuration
    }
    
    func get<T>(_ type: T.Type,
                path: String,
                queryItems: [URLQueryItem]?) async throws -> T where T : Decodable {
        
        let urlString = "\(WSREnvironment.gitHubBaseURL)\(path)"
        
        guard var url = URL(string: urlString) else {
            throw WSRApiError.badURL
        }
        
        if let queryItems = queryItems {
            url.append(queryItems: queryItems)
        }
        
        let session = URLSession(configuration: WSRApiService.getURLSessionConfiguration())
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw WSRApiError.serverError
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if (400...499).contains(httpResponse.statusCode) {
                throw WSRApiError.badRequest
            }
            else if (500...599).contains(httpResponse.statusCode) {
                throw WSRApiError.serverError
            }
            else {
                throw WSRApiError.badResponse(statusCode: httpResponse.statusCode)
            }
        }
        
        logger.api(request: request, httpResponse: httpResponse, data: data)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(type, from: data)
        }
        catch(let error) {
            throw WSRApiError.parsing(error as? DecodingError)
        }
    }
    
    func post(path: String, bodyParam: String) {
        
    }
    
    func put(path: String, bodyParam: String) {
        
    }
    
    func delete(path: String, bodyParam: String) {
        
    }
    
    
}
