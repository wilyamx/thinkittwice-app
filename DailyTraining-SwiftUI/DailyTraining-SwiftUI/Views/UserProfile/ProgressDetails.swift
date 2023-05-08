//
//  ProgressDetails.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 5/8/23.
//

import SwiftUI

struct ProgressDetails: View {
    var body: some View {
        VStack(spacing: 5) {
            Text("Level 1")
                .font(.body)
                .minimumScaleFactor(0.6)
            ProgressView(value: 0.5)
                .frame(width: 250)
            Text("500 / 1 000 points")
                .foregroundColor(.secondary)
                .font(.footnote)
                .minimumScaleFactor(0.6)
        }
    }
}

struct ProgressDetails_Previews: PreviewProvider {
    static var previews: some View {
        ProgressDetails()
    }
}
