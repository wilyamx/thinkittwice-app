//
//  ContentView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/3/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DailyTrainingViewModel()
    
    var body: some View {
        LoginScreen()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ProfileViewModel())
    }
}
