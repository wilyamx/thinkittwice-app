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
    
    override init(service: WSRApiServiceProtocol = WSRApiService()) {
        super.init(service: service)
    }
    
    init(service: WSRApiServiceProtocol = WSRApiService(),
         userDetails: GitHubUser,
         mockedData: Bool = false) {
        
        super.init(service: service)
        self.userDetails = userDetails
        self.mockData = mockedData
    }
    
    public func getUserDetails() async {
        var cats: [BreedModel] = []
        var user: GitHubUser?
        
        logger.api(message: "Asynchronous requests...")
        requestStarted(message: String.user_details.localizedString())
        
        do {
            if mockData {
                cats = try await MockCatApiService().get([BreedModel].self,
                                                     path: CatApiEndpoints.breeds,
                                                     queryItems: nil)
                user = try await MockGitHubApiService().get(GitHubUser.self,
                                                        path: GithubApiEndpoints.userDetails,
                                                        queryItems: nil)
            }
            else {
                cats = try await CatApiService().get([BreedModel].self,
                                                     path: CatApiEndpoints.breeds,
                                                     queryItems: nil)
                user = try await GitHubApiService().get(GitHubUser.self,
                                                        path: GithubApiEndpoints.userDetails,
                                                        queryItems: nil)
            }
            
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
        }
        catch(let error) {
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
        
        if mockData {
            CatApiService().getCatBreedsUsingCombineMocked(urlString: urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        logger.error(message: error.localizedDescription)
                        break
                    }
                } receiveValue: { cats in
                    logger.api(message: "cats: \(cats.count)")
                }
                .store(in: &cancellables)
        }
        else {
            CatApiService().getCatBreedsUsingCombine(urlString: urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        logger.error(message: error.localizedDescription)
                        break
                    }
                } receiveValue: { cats in
                    logger.api(message: "cats: \(cats.count)")
                }
                .store(in: &cancellables)
        }
    }
    
    func getUserInfoUsingCombine() {
        let endpoint = GithubApiEndpoints.userDetails
        let urlString = "\(WSREnvironment.gitHubBaseURL)\(endpoint)"
        
        if mockData {
            GitHubApiService().getUserInfoUsingCombineMocked(urlString: urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        logger.error(message: error.localizedDescription)
                        break
                    }
                } receiveValue: { [weak self] info in
                    self?.userDetails = info
                    logger.api(message: "info: \(info.name)")
                }
                .store(in: &cancellables)
        }
        else {
            GitHubApiService().getUserInfoUsingCombine(urlString: urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        logger.error(message: error.localizedDescription)
                        break
                    }
                } receiveValue: { [weak self] info in
                    self?.userDetails = info
                    logger.api(message: "info: \(info.name)")
                }
                .store(in: &cancellables)
        }
    }
    
}
