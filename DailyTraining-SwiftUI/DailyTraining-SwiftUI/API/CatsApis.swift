//
//  CatsApis.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/5/23.
//

import SwiftUI

extension WSRApiService {
    
    func getCatBreeds(urlString: String) async throws -> [Breed] {
        guard let url = URL(string: urlString) else {
            throw WSRApiError.badURL
        }
        
        let session = URLSession(configuration: WSRApiService.getURLSessionConfiguration())
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw WSRApiError.serverError
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw WSRApiError.badResponse(statusCode: httpResponse.statusCode)
        }
        
        logger.api(request: request, httpResponse: httpResponse, data: data)
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Breed].self, from: data)
        }
        catch(let error) {
            throw WSRApiError.parsing(error as? DecodingError)
        }
    }
    
}
