//
//  ModifiedLoaderView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 11/10/23.
//

import SwiftUI

struct ModifiedLoaderView: View {
    @ObservedObject var viewModel = ModifiedLoaderViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                Text(String("Fetcher 2 Modifiers"))
                    .font(.title)
                    .bold()
                
                Button {
                    viewModel.requestStarted(message: String.calculating.localizedString())
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + 2,
                        execute: {
                            viewModel.requestSuccess()
                        })
                    
                } label: {
                    Text("Successful Request")
                        .foregroundColor(.white)
                        .padding()
                        .background(.gray)
                        .cornerRadius(10)
                }
                
                Button {
                    viewModel.requestStarted(message: String.authenticating.localizedString())
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + 2,
                        execute: {
                            viewModel.requestFailed(
                                reason: "Invalid Credential",
                                errorAlertType: .somethingWentWrong
                            )
                        })
                    
                } label: {
                    Text("Something Went Wrong!")
                        .foregroundColor(.white)
                        .padding()
                        .background(.gray)
                        .cornerRadius(10)
                }
                
                Button {
                    viewModel.requestStarted(message: String.logging_in.localizedString())
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + 2,
                        execute: {
                            viewModel.requestFailed(
                                reason: "Invalid Credential",
                                errorAlertType: .domain
                            )
                        })
                } label: {
                    Text("Domain Error")
                        .foregroundColor(.white)
                        .padding()
                        .background(.gray)
                        .cornerRadius(10)
                }
                
                Button {
                    viewModel.requestStarted(message: String.logging_in.localizedString())
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + 2,
                        execute: {
                            viewModel.requestFailed(
                                reason: "Check payload",
                                errorAlertType: .badRequest
                            )
                        })
                } label: {
                    Text("Bad Request")
                        .foregroundColor(.white)
                        .padding()
                        .background(.gray)
                        .cornerRadius(10)
                }
                
                Button {
                    viewModel.requestStarted(message: String.logging_in.lowercased())
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + 2,
                        execute: {
                            viewModel.requestFailed(
                                reason: "Check payload",
                                errorAlertType: .connectionTimedOut
                            )
                        })
                } label: {
                    Text("Connection Timeout")
                        .foregroundColor(.white)
                        .padding()
                        .background(.gray)
                        .cornerRadius(10)
                }
                
                Button {
                    viewModel.requestStarted(message: String.logging_in.localizedString())
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + 2,
                        execute: {
                            viewModel.requestFailed(
                                reason: "Check payload",
                                errorAlertType: .noInternetConnection
                            )
                        })
                } label: {
                    Text("No internet connection")
                        .foregroundColor(.white)
                        .padding()
                        .background(.gray)
                        .cornerRadius(10)
                }
            }
        }
        .wsr_ErrorAlertView(viewModel: viewModel)
        .wsr_LoadingView(viewModel: viewModel)
    }
}

struct ModifiedLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        ModifiedLoaderView()
            .previewDisplayName("en")
            .environment(\.locale, .init(identifier: "en"))
        
        ModifiedLoaderView()
            .previewDisplayName("fr")
            .environment(\.locale, .init(identifier: "fr"))
        
        ModifiedLoaderView()
            .previewDisplayName("ar")
            .environment(\.locale, .init(identifier: "ar"))
    }
}
