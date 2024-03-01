//
//  GitHubApiService.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 7/13/23.
//

import Foundation
import Combine

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

extension GitHubApiService {
    
    func getUserInfoUsingCombine(
        urlString: String
    ) -> AnyPublisher<GitHubUser, WSRApiError> {
        
        guard let url = URL(string: urlString) else {
            let apiError = WSRApiError.badURL
            return (
                Fail(error: apiError)
                    .eraseToAnyPublisher()
            )
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: GitHubUser.self, decoder: decoder)
            .mapError({ error in
                return WSRApiError.parsing(error as? DecodingError)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getUserInfoUsingCombineMocked(
        urlString: String
    ) -> AnyPublisher<GitHubUser, WSRApiError> {
        
        if let path = Bundle.main.url(
            forResource: "GithubUser",
            withExtension: ".json") {
            do {
                let data = try Data(contentsOf: path)
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let objectList = try decoder.decode(GitHubUser.self, from: data)
                
                return (
                    Just(objectList)
                        .tryMap({ $0 })
                        .mapError({ error in
                            return WSRApiError.parsing(error as? DecodingError)
                        })
                        .eraseToAnyPublisher()
                )
            } catch {
                logger.error(message: "\(error.localizedDescription)")
                return (
                    Fail(error: WSRApiError.parsing(error as? DecodingError))
                        .eraseToAnyPublisher()
                )
            }
        }
        else {
            logger.error(message: "GithubUser.json not found!")
            return (
                Fail(error: WSRApiError.badURL)
                    .eraseToAnyPublisher()
            )
        }
    }
}
