//
//  WSRApiService.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/11/23.
//

import Foundation

struct WSRApiService: WSRApiServiceProtocol {
    
    // MARK: - Generics
    /**
        Using Generics
    
        fetch(
         [BreedModel].self,
         urlString: urlString,
         completion: { [weak self] result in
         })
     */
    func fetch<T: Decodable>(
        _ type: T.Type,
        urlString:String,
        completion: @escaping(Result<T, WSRApiError>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            let error = WSRApiError.badURL
            completion(Result.failure(error))
            return
        }
        
        logger.api(message: urlString)
        
        URLSession.shared.dataTask(
            with: url,
            completionHandler: {
                data, response, error -> Void in
                
                if let error = error as? URLError {
                    completion(Result.failure(WSRApiError.url(error)))
                } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    completion(Result.failure(WSRApiError.badResponse(statusCode: response.statusCode)))
                } else if let data = data {
                    let decoder = JSONDecoder()
                    //decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let responseModel = try decoder.decode(type, from: data)
                        completion(Result.success(responseModel))
                    } catch {
                        completion(Result.failure(WSRApiError.parsing(error as? DecodingError)))
                    }
                }
            }).resume()
    }
    
    // MARK: - WSRApiServiceProtocol
    
    static func getURLSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        return configuration
    }
    
    // MARK: - Restful methods
    
    public func get<T: Decodable>(
        _ type: T.Type,
        path: String,
        queryItems: [URLQueryItem]?) async throws -> T {
            
        var urlString = "\(WSREnvironment.catBaseURL)\(path)"
        if path.contains("/users/wilyamx") {
            urlString = "\(WSREnvironment.gitHubBaseURL)\(path)"
        }
        
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
            if path.contains("/users/wilyamx") {
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            }
            return try decoder.decode(type, from: data)
        }
        catch(let error) {
            throw WSRApiError.parsing(error as? DecodingError)
        }
    }
    
    public func post(path: String, bodyParam: String) {
        
    }
    
    public func put(path: String, bodyParam: String) {
        
    }
    
    public func delete(path: String, bodyParam: String) {
        
    }
}

