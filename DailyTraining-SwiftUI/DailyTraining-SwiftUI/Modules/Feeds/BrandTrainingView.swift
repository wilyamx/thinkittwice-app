//
//  BrandTrainingView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/6/23.
//

import SwiftUI

struct BrandTrainingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("BRAND TRAINING")
                .fontWeight(.bold)
                                    
            Image("butterfly")
                .resizable()
                .frame(height: 200)
                .cornerRadius(15)
            
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                .lineLimit(4)
            
            Button(action: { },
                   label: {
                Text("TAKE THE COURSE")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(.black)
                    .font(.footnote)
            })
            .cornerRadius(10)
        }
    }
}

struct BrandTrainingView_Previews: PreviewProvider {
    static var previews: some View {
        BrandTrainingView()
    }
}
