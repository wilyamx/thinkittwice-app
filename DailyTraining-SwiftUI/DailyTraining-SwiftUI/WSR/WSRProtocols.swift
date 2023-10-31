//
//  WSRProtocols.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 10/31/23.
//

import Foundation

protocol WSRViewStateProtocol {
    var viewState: WSRViewState { get set }
    var errorMessage: String { get set }
}
