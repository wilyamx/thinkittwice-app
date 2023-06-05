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
            return try decoder.decode([Breed].self, from: data)
        }
        catch(let error) {
            throw WSRApiError.parsing(error as? DecodingError)
        }
    }
    
}
