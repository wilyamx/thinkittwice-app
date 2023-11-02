//
//  WSRProtocols.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 10/31/23.
//

import Foundation

protocol WSRViewStateProtocol {
    var viewState: WSRViewState { get set }
    var showErrorAlert: Bool { get set }
    //
    var loadingMessage: String { get set }
    var errorMessage: String { get set }
    var errorAlertType: WSRErrorAlertType { get set }
}

protocol WSRPersitableProtocol {
    func persist() async
}
