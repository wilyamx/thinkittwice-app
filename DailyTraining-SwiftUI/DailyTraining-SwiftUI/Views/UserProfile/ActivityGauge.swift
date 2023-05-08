//
//  ActivityGauge.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/8/23.
//

import SwiftUI

struct ActivityGauge: View {
    var value: String
    var dimension: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .minimumScaleFactor(0.3)
            Text(dimension)
                .foregroundColor(.secondary)
                .minimumScaleFactor(0.5)
                .font(.caption)
        }
    }
}

struct ActivityGauge_Previews: PreviewProvider {
    static var previews: some View {
        ActivityGauge(value: "80%", dimension: "Rate")
    }
}
