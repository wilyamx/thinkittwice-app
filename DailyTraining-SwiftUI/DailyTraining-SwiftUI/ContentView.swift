//
//  ContentView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DailyTrainingViewModel()
    
    @ObservedObject private var loginViewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            if loginViewModel.isReturneeUser {
                SplashScreen()
            }
            else {
                LoginView()
                    .environmentObject(LoginViewModel())
            }
        }
        .onAppear {
            loginViewModel.checkForReturneeUser()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
