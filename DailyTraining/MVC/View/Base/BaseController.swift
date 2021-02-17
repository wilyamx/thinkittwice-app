//
//  BaseController.swift
//  DailyTraining
//
//  Created by Andrew Daugdaug on 09/04/2019.
//  Copyright © 2019 Andrew Daugdaug. All rights reserved.
//

import Foundation

public enum WebServiceErrors: Int  {
    case forbidden = 403
    case badRequest = 400
    var title: String {
        switch self {
        case .forbidden:
            return "Forbidden"
        case .badRequest:
            return "Bad Request"
        }
    }
}

class BaseController: NSObject {
    lazy var userManager = UserManager()
    lazy var connection = ConnectionController()
    
    func checkConnection(next: @escaping (Bool, String) -> ()) {
        if connection.noConnection() {
            next(true, LocalizedError.noNetwork.localizedDescription)
        }
        else {
            next(false, "")
        }
    }
    
    func checkWebServiceError(errorCode code: Int, proceed:((Bool)->())? = nil) {
        switch code {
        case LocalizedError.Unauthorized.rawValue:
            if (userManager.getStandByUsers().count <= 1) {
                userManager.deleteLoginUser()
                NotificationCenter.default.post(name: .forceLogoutUser, object: nil)
            }
            else {
                userManager.loginNextUser()
            }
        default:
            if let proceed = proceed {
                proceed(true)
            }
        }
    }
}
