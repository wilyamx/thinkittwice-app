//
//  WSRLoadingViewModifier.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 11/10/23.
//

import SwiftUI

struct WSRLoadingViewModifier: ViewModifier {
    @ObservedObject var viewModel: WSRFetcher2
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if viewModel.viewState == .loading {
                Color.black
                    .opacity(0.25)
                
                WSRProcessingView(loadingMessage: viewModel.loadingMessage)
            }
        }
        
    }
}
