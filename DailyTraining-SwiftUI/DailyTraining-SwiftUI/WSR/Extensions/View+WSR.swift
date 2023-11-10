//
//  View+Extension.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/4/23.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
        )
    }
}
#endif

// MARK: - WSRButtonLabelModifier

extension View {
    func wsr_ButtonLabel(bgColor: Color, fgColor: Color, font: Font? = nil) -> some View {
        modifier(
            WSRButtonLabelModifier(
                bgColor: bgColor,
                fgColor: fgColor,
                font: font
            )
        )
    }
}

// MARK: - WSRFetcher2 Modifiers

extension View {
    func wsr_ErrorAlertView(viewModel: WSRFetcher2) -> some View {
        modifier(
            WSRErrorAlertViewModifier(viewModel: viewModel)
        )
    }
    
    func wsr_LoadingView(viewModel: WSRFetcher2) -> some View {
        modifier(
            WSRLoadingViewModifier(viewModel: viewModel)
        )
    }
}
