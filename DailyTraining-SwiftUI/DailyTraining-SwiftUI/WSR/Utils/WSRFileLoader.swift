//
//  WSRFileLoader.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/11/23.
//

import Foundation

struct WSRFileLoader {
    /**
        Using Generics
     */
    func loadJSON<T: Decodable>(
        _ filename: String,
        _ type: T.Type,
        completion: @escaping(Result<T, WSRFileLoaderError>) -> Void) {
            
        guard let file = Bundle.main.url(forResource: filename,
                                         withExtension: nil)
        else {
            completion(Result.failure(WSRFileLoaderError.fileNotFound(filename)))
            return
        }

        logger.log(category: .fileloader, message: "filename: \(filename)")
        
        var data: Data = Data()
            
        do {
            data = try Data(contentsOf: file)
        } catch {
            completion(Result.failure(WSRFileLoaderError.fileCannotLoad(error)))
        }

        do {
            let decoder = JSONDecoder()
            let responseModel = try decoder.decode(type, from: data)
            completion(Result.success(responseModel))
        } catch {
            completion(Result.failure(WSRFileLoaderError.parsing(error as? DecodingError)))
        }
    }

    func loadJSON<T: Decodable>(_ filename: String) -> T {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }

}

class WSRLocalFileLoader: ObservableObject {
    var fileLoader: WSRFileLoader
    
    init(fileLoader: WSRFileLoader = WSRFileLoader()) {
       self.fileLoader = fileLoader
    }
}
