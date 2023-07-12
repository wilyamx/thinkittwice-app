//
//  CatApiService.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 7/13/23.
//

import Foundation

struct CatApiService: WSRApiServiceProtocol {
    
    static func getURLSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        return configuration
    }
    
    func get<T>(_ type: T.Type,
                path: String,
                queryItems: [URLQueryItem]?) async throws -> T where T : Decodable {
        
        let urlString = "\(WSREnvironment.catBaseURL)\(path)"
        
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

extension CatApiService {
    /**
     self.service.getCatBreeds(
         urlString: urlString,
         completion: { [unowned self]
             result in
             switch result {
             case .failure(let error):
                 self.errorMessage = error.localizedDescription
             case .success(let breeds):
                 self.breeds = breeds
             }
         })
     */
    func getCatBreeds(
        urlString: String,
        completion: @escaping(Result<[BreedModel], WSRApiError>) -> Void) {
        
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
                    do {
                        let responseModel = try decoder.decode([BreedModel].self, from: data)
                        completion(Result.success(responseModel))
                    } catch {
                        completion(Result.failure(WSRApiError.parsing(error as? DecodingError)))
                    }
                }
            }).resume()
    }
}
