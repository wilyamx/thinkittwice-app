//
//  WSRApiService.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/11/23.
//

import Foundation

struct WSRApiService: WSRApiServiceProtocol {
    /**
        Using Generics
    
        fetch(
         [Breed].self,
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
                    do {
                        let responseModel = try decoder.decode(type, from: data)
                        completion(Result.success(responseModel))
                    } catch {
                        completion(Result.failure(WSRApiError.parsing(error as? DecodingError)))
                    }
                }
            }).resume()
    }
    
    static func getURLSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        return configuration
    }
}

