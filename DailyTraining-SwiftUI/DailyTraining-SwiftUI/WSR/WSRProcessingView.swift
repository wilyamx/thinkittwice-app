//
//  WSRProcessingView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 11/10/23.
//

import SwiftUI

struct WSRProcessingView: View {
    let gradientColor = LinearGradient(
        gradient: Gradient(colors: [.orange, .black]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    @State var loadingMessage: String = "Loading"
    
    var body: some View {
        VStack {
            ProgressView {
                Text(loadingMessage)
                    .foregroundColor(.orange)
                    .font(.title)
                    .bold()
            }
            .tint(.orange)
            .controlSize(.large)
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
