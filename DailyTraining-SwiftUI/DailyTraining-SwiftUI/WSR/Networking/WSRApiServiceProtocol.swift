//
//  WSRApiServiceProtocol.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/16/23.
//

import Foundation

protocol WSRApiServiceProtocol {

    static func getURLSessionConfiguration() -> URLSessionConfiguration
    
    // MARK: - Restful methods
    
    func get<T: Decodable>(
        _ type: T.Type,
        path: String,
        queryItems: [URLQueryItem]?) async throws -> T
    
    func post(path: String, bodyParam: String)
    func put(path: String, bodyParam: String)
    func delete(path: String, bodyParam: String)
}
