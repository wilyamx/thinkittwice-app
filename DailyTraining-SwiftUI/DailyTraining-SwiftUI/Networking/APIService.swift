//
//  APIService.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/11/23.
//

import Foundation

struct APIService {

    /**
        Using Generics
     */
    func fetch<T: Decodable>(
        _ type: T.Type,
        url:URL?,
        completion: @escaping(Result<T, APIError>) -> Void) {
        
        guard let url = url else {
            let error = APIError.badURL
            completion(Result.failure(error))
            return
        }
        
        URLSession.shared.dataTask(
            with: url,
            completionHandler: {
                data, response, error -> Void in
                
                if let error = error as? URLError {
                    completion(Result.failure(APIError.url(error)))
                } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    completion(Result.failure(APIError.badResponse(statusCode: response.statusCode)))
                } else if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let responseModel = try decoder.decode(type, from: data)
                        completion(Result.success(responseModel))
                    } catch {
                        completion(Result.failure(APIError.parsing(error as? DecodingError)))
                    }
                }
            }).resume()
    }
    
    func getCatBreeds(
        url:URL?,
        completion: @escaping(Result<[Breed], APIError>) -> Void) {
        
        guard let url = url else {
            let error = APIError.badURL
            completion(Result.failure(error))
            return
        }
        
        URLSession.shared.dataTask(
            with: url,
            completionHandler: {
                data, response, error -> Void in
                
                if let error = error as? URLError {
                    completion(Result.failure(APIError.url(error)))
                } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    completion(Result.failure(APIError.badResponse(statusCode: response.statusCode)))
                } else if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let responseModel = try decoder.decode([Breed].self, from: data)
                        completion(Result.success(responseModel))
                    } catch {
                        completion(Result.failure(APIError.parsing(error as? DecodingError)))
                    }
                }
            }).resume()
    }

}
