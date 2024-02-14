//
//  WSRProcessingView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 11/10/23.
//

import SwiftUI

struct WSRProcessingView: View {
    let gradientColor = LinearGradient(
        gradient: Gradient(colors: [.green, .black]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    @State var loadingMessage: String = "Loading"
    
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "eyes")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.black)
                
                Text(LocalizedStringKey(String.daily_training))
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.yellow)
                
                Text(String.solution.localizedString().uppercased())
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .tracking(10)
                
                ProgressView(){
                    Text(loadingMessage)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.orange)
                        .font(.title2)
                        .bold()
                }
                    .tint(.white)
                    .controlSize(.large)
                    .padding()
            }
        }
        .padding(40)
        .background(gradientColor).opacity(0.95)
        .cornerRadius(20)
    }
}

struct WSRProcessingView_Previews: PreviewProvider {
    static var previews: some View {
        WSRProcessingView(loadingMessage: "Processing")
    }
}
