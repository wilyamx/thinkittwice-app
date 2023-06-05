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
        
        logger.api(message: urlString)
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw WSRApiError.serverError
        }
        
        guard httpResponse.statusCode == 200 else {
            throw WSRApiError.badResponse(statusCode: httpResponse.statusCode)
        }
        
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
