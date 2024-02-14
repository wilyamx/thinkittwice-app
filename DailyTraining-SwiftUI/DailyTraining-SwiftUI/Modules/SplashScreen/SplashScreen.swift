//
//  SplashScreen.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/9/23.
//

import SwiftUI
import Foundation

struct SplashScreen: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            LandingScreen()
                .environmentObject(TabViewModel())
                .environmentObject(ProfileViewModel())
        }
        else {
            ZStack {
                ColorNames.accentColor.colorValue
                    .ignoresSafeArea()
                VStack {
                    Image(systemName: "eyes")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(LocalizedStringKey(String.daily_training))
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.purple)
                    
                    Text(String.solution.localizedString().uppercased())
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .tracking(10)
                    
                    ProgressView()
                        .scaleEffect(2)
                        .padding()
                }
            }
            .onAppear {
                self.gotoLandingScreen(time: 3.0)
            }
        }
    }
    
    func gotoLandingScreen(time: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(time)) {
            self.isActive = true
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
