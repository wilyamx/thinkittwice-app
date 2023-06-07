//
//  BrandTrainingView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/6/23.
//

import SwiftUI

struct BrandTrainingView: View {
    var cat: Cat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("BRAND TRAINING")
                .fontWeight(.bold)
                                    
            WSRRemoteImage(url: cat.imageUrl())
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.white)
                .background(Color.secondary.opacity(0.5))
                .clipped()
                .cornerRadius(15)
            
            Text(cat.breedExplanation)
                .lineLimit(4)
            
            Button(action: {
                logger.info(message: "Take the course! \(cat.name) (\(cat.referenceImageId).jpg)")
            },
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
        List {
            BrandTrainingView(cat: Cat.example())
        }
        .buttonStyle(.borderless)
    }
}
