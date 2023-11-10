//
//  WSRErrorAlertViewModifier.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 11/10/23.
//

import SwiftUI

struct WSRErrorAlertViewModifier: ViewModifier {
    @ObservedObject var viewModel: WSRFetcher2
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if viewModel.showErrorAlert {
                WSRErrorAlertView(
                    showErrorAlert: $viewModel.showErrorAlert,
                    errorAlertType: viewModel.errorAlertType,
                    closeErrorAlert: {
                        logger.info(message: "Close!")
                    })
            }
        }
        
    }
}
