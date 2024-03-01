//
//  RankingRateCircularBar.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/8/23.
//

import SwiftUI

struct RankingRateCircularBar: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 150)
                .foregroundColor(.white)
            
            Circle()
                .stroke(
                    ColorNames.listBackgroundColor.colorValue,
                    lineWidth: 10
                )
                .frame(width: 140)
            
            Circle()
                .trim(from: 0, to: 0.25)
                .stroke(
                    Color.accentColor,
                    style: StrokeStyle(lineWidth: 10,
                                       lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .frame(width: 140)
            
            VStack(spacing: 5) {
                Text("Combo")
                    .foregroundColor(.secondary)
                    .minimumScaleFactor(0.75)
                Text(String("2"))
                    .font(.title)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.75)
                Text("Days")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .minimumScaleFactor(0.75)
            }
        }
    }
}

struct RankingRateCircularBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
            RankingRateCircularBar()
        }
    }
}
