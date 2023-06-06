//
//  GitHubApis.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/5/23.
//

import Foundation

extension WSRApiService {
    
    func getUserDetails(urlString: String) async throws -> GitHubUser {
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
        
        guard httpResponse.statusCode == 200 else {
            throw WSRApiError.badResponse(statusCode: httpResponse.statusCode)
        }
        
        logger.api(request: request, httpResponse: httpResponse, data: data)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            return try decoder.decode(GitHubUser.self, from: data)
        }
        catch(let error) {
            throw WSRApiError.parsing(error as? DecodingError)
        }
    }
    
}
