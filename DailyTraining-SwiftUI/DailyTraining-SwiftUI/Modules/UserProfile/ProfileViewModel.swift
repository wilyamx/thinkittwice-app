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
    
    public func getUserDetails() async {
        guard userDetails == nil else {
            logger.info(message: "using mock data")
            return
            
        }
        
        var cats: [BreedModel] = []
        var user: GitHubUser?
        
        logger.api(message: "Asynchronous requests...")
        self.requestStarted()
        
        do {
            cats = try await CatApiService().get([BreedModel].self,
                                                 path: CatApiEndpoints.breeds,
                                                 queryItems: nil)
            user = try await GitHubApiService().get(GitHubUser.self,
                                                    path: GithubApiEndpoints.userDetails,
                                                    queryItems: nil)
            
            logger.api(message: "cats: \(cats.count)")
            if let user2 = user {
                logger.api(message: "user: \(user2)")
            }
            
            userDetails = user
            
            self.requestSuccess()
            
        } catch(let error) {
            if let error = error as? WSRApiError {
                logger.error(message: error.localizedDescription)
            }
            self.requestFailed(reason: error.localizedDescription)
        }
    
    }
    
    public func logout() {
        guard let email = getUserEmail() else {
            return
        }
        guard let activeUser = registeredUsers.first(where: {
            $0.email == email
        }) else {
            return
        }
        
        self.logoutButtonAction = "Logging out..."
        
        logger.realm(message: "Logout registered user! \(email)")
        //deleteRegisteredUser(user: activeUser)
        //resetUserEmail()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isLoggedOut = true
        }
    }
    
    private func deleteRegisteredUser(user: User) {
        try! realm.write {
            realm.delete(user)
        }
    }

}

// MARK: - Setters and Getters

extension ProfileViewModel {
    func getUserEmail() -> String? {
        UserDefaults.standard.string(forKey: WSRUserDefaultsKey.email.rawValue)
    }
    
    func resetUserEmail() {
        UserDefaults.standard.removeObject(forKey: WSRUserDefaultsKey.email.rawValue)
    }
    
    public func showActiveEmail() {
        if let email = getUserEmail() {
            logger.info(message: "Active user: \(email)!")
        }
    }
}
