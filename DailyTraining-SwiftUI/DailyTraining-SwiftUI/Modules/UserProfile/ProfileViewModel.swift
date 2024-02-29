//
//  ProfileViewModel.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/8/23.
//

import SwiftUI
import RealmSwift
import Combine

final class ProfileViewModel: WSRFetcher2 {
    @Published var isLoggedOut: Bool = false
    @Published var logoutButtonAction: LocalizedStringKey = LocalizedStringKey(String.logout)
    
    @Published var userDetails: GitHubUser?
    
    // realm
    @Environment(\.realm) var realm
    @ObservedResults(User.self) var registeredUsers
    
    // combine
    var cancellables = Set<AnyCancellable>()
    
    init(service: WSRApiServiceProtocol = WSRApiService(), userDetails: GitHubUser) {
        super.init(service: service)
        self.userDetails = userDetails
    }
    
    override init(service: WSRApiServiceProtocol = WSRApiService()) {
        super.init(service: service)
    }
    
    public func getUserDetails() async {
        var cats: [BreedModel] = []
        var user: GitHubUser?
        
        logger.api(message: "Asynchronous requests...")
        requestStarted(message: String.user_details.localizedString())
        
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
            
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 1,
                execute: {
                    self.requestSuccess()
                })
        } catch(let error) {
            if let error = error as? WSRApiError {
                self.requestFailed(reason: error.localizedDescription)
                logger.error(message: error.localizedDescription)
            }
            else if let error = error as? URLError {
                if error.code == .notConnectedToInternet {
                    self.requestFailed(
                        reason: error.localizedDescription,
                        errorAlertType: .noInternetConnection
                    )
                }
                else {
                    self.requestFailed(
                        reason: error.localizedDescription,
                        errorAlertType: .somethingWentWrong
                    )
                }
            }
        }
    
    }
    
    public func logout() {
        guard let email = getUserEmail() else {
            return
        }
        guard let _ = registeredUsers.first(where: {
            $0.email == email
        }) else {
            return
        }
        
        self.logoutButtonAction = LocalizedStringKey(String.logout)
        
        logger.realm(message: "Logout registered user! \(email)")
        UserDefaults.standard.removeObject(forKey: WSRUserDefaultsKey.isLoggedOut.rawValue)
        UserDefaults.standard.removeObject(forKey: WSRUserDefaultsKey.email.rawValue)
        //deleteRegisteredUser(user: activeUser)
        
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
    
    public func showActiveEmail() {
        if let email = getUserEmail() {
            logger.info(message: "Active user: \(email)!")
        }
    }
}

// MARK: - Using Combine

extension ProfileViewModel {
    func getBreedsUsingCombine() {
        let endpoint = CatApiEndpoints.breeds
        let urlString = "\(WSREnvironment.catBaseURL)\(endpoint)"
        
        CatApiService().getCatBreedsUsingCombine(urlString: urlString)
            .sink { _ in
                
            } receiveValue: { cats in
                logger.api(message: "cats: \(cats.count)")
            }
            .store(in: &cancellables)
    }
    
    func getUserInfoUsingCombine() {
        let endpoint = GithubApiEndpoints.userDetails
        let urlString = "\(WSREnvironment.gitHubBaseURL)\(endpoint)"
        
        GitHubApiService().getUserInfoUsingCombine(urlString: urlString)
            .sink { _ in
                
            } receiveValue: { info in
                logger.api(message: "info: \(info.avatarUrl)")
            }
            .store(in: &cancellables)
    }
    
}
