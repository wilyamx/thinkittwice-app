//
//  BreedTests.swift
//  DailyTraining-SwiftUITests
//
//  Created by William Rena on 5/16/23.
//

import XCTest
import Combine

@testable import DailyTraining_SwiftUI

final class BreedTests: XCTestCase {

    var subscriptions = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        subscriptions = []
    }

    func testGettingBreedsSuccess() {
        let promise = expectation(description: "getting breeds")
        
        let result = Result<[Breed], APIError>.success([Breed.example1()])
        let fetcher = BreedFetcher(service: APIServiceMock(result: result))
        
        fetcher.$breeds.sink { breeds in
            if breeds.count > 0 {
                promise.fulfill()
            }
        }.store(in: &subscriptions)
        
        wait(for: [promise], timeout: 2)
    }
    
    func testLoadingError() {
        let promise = expectation(description: "show error message")
        
        let result = Result<[Breed], APIError>.failure(APIError.badURL)
        let fetcher = BreedFetcher(service: APIServiceMock(result: result))
        
        fetcher.$breeds.sink { breeds in
            if !breeds.isEmpty {
                XCTFail()
            }
        }.store(in: &subscriptions)
        
        fetcher.$errorMessage.sink { message in
            if message != nil {
                promise.fulfill()
            }
        }.store(in: &subscriptions)
        
        wait(for: [promise], timeout: 2)
    }
        
}
