//
//  ProfileViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/8/23.
//

import SwiftUI
import RealmSwift

final class ProfileViewModel: WSRFetcher {
    @Published var isLoggedOut: Bool = false
    @Published var logoutButtonAction: String = "Logout"
    
    @Published var userDetails: GitHubUser?
    
    // realm
    @Environment(\.realm) var realm
    @ObservedResults(User.self) var registeredUsers
    
    init(service: WSRApiServiceProtocol = WSRApiService(), userDetails: GitHubUser) {
        super.init(service: service)
        self.userDetails = userDetails
    }
    
    override init(service: WSRApiServiceProtocol = WSRApiService()) {
        super.init(service: service)
    }
    
    func getUserDetails() async {
        guard userDetails == nil else {
            logger.info(message: "using mock data")
            return
            
        }
        
        var cats: [BreedModel] = []
        var user: GitHubUser?
        
        logger.api(message: "Asynchronous requests...")
        self.requestStarted()
        
        do {
            cats = try await WSRApiService().getCatBreeds(urlString: "https://api.thecatapi.com/v1/breeds")
            user = try await WSRApiService().getUserDetails(urlString: "https://api.github.com/users/wilyamx")
            
            logger.api(message: "cats: \(cats.count)")
            if let user2 = user {
                logger.api(message: "user: \(user2)")
            }
            
            userDetails = user
            
            self.requestSuccess()
            
        } catch(let error) {
            logger.error(message: "Error! \(error.localizedDescription)")
            self.requestFailed(reason: error.localizedDescription)
        }
    
    }
    
    func logout() {
        self.logoutButtonAction = "Logging out..."
        
        logger.realm(message: "Deleting all registered users!")
        registeredUsers.forEach { user in
            try! realm.write {
                realm.delete(user)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isLoggedOut = true
        }
    }
}
