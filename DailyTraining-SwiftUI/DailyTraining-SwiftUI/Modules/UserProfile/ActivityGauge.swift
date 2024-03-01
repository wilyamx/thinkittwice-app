//
//  ActivityGauge.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/8/23.
//

import SwiftUI

struct ActivityGauge: View {
    var value: String
    var dimension: LocalizedStringKey
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(String(value))
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
        ZStack {
            Color.white
            ActivityGauge(
                value: "80%",
                dimension: LocalizedStringKey(String.rate)
            )
        }
        .previewDisplayName("en")
        .environment(\.locale, .init(identifier: "en"))
        
        ZStack {
            Color.white
            ActivityGauge(
                value: "80%",
                dimension: LocalizedStringKey(String.rate)
            )
        }
        .previewDisplayName("fr")
        .environment(\.locale, .init(identifier: "fr"))
        
        ZStack {
            Color.white
            ActivityGauge(
                value: "80%",
                dimension: LocalizedStringKey(String.rate)
            )
        }
        .previewDisplayName("ar")
        .environment(\.locale, .init(identifier: "ar"))
    }
}
