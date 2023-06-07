//
//  RetryView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/5/23.
//

import SwiftUI

struct RetryView: View {
    var message: String
    
    var body: some View {
        VStack {
            Image(systemName: "info.circle")
                .font(.system(size: 50))
                .foregroundColor(.red)
                .padding(5)
            Text(message)
                .multilineTextAlignment(.center)
            Button(action: {
                
            },
                   label: {
                Text("Tap to Retry")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(width: 150, height: 40)
                    .background(ColorNames.accentColor.colorValue)
                    .clipShape(Capsule())
            })

        }
    }
}

struct ReloadView_Previews: PreviewProvider {
    static var previews: some View {
        RetryView(message: "The request time out")
    }
}
