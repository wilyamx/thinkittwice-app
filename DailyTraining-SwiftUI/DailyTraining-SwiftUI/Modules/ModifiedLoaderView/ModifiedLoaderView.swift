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
        VStack(spacing: 20) {
            
            Button {
                viewModel.requestStarted(message: "Calculating")
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
                viewModel.requestStarted(message: "Calculating")
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
                viewModel.showErrorAlert.toggle()
            } label: {
                Text("Domain Error")
                    .foregroundColor(.white)
                    .padding()
                    .background(.gray)
                    .cornerRadius(10)
            }

        }
        .wsr_ErrorAlertView(viewModel: viewModel)
        .wsr_LoadingView(viewModel: viewModel)
    }
}

struct ModifiedLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        ModifiedLoaderView()
    }
}
