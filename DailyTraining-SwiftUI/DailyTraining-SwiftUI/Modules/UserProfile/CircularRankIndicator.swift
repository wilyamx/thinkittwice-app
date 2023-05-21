//
//  CircularRankIndicator.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/8/23.
//

import SwiftUI

struct CircularRankIndicator: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 150)
                .foregroundColor(Color(ColorNames.listBackgroundColor.rawValue))
            
            VStack(spacing: 5) {
                Text("Rank")
                    .foregroundColor(.secondary)
                    .minimumScaleFactor(0.75)
                Text("11th")
                    .font(.title)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.75)
                Text("/ 30")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .minimumScaleFactor(0.75)
            }
        }
    }
}

struct CircularRankIndicator_Previews: PreviewProvider {
    static var previews: some View {
        CircularRankIndicator()
    }
}
