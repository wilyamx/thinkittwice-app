//
//  BrandTrainingView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/6/23.
//

import SwiftUI
import RealmSwift

struct BrandTrainingView: View {
    var cat: Cat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("BRAND TRAINING")
                .fontWeight(.bold)
                                    
            WSRWebImage(url: cat.imageUrl())
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
                logger.info(message: "\(cat.breedExplanation)")
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
    /**
        https://www.mongodb.com/docs/realm/sdk/swift/swiftui/swiftui-previews/
     */
    static var previews: some View {
        List {
            let realm = WSRMockRealms.previewRealm
            let cats = realm.objects(Cat.self)
            
            if let cat = cats.first {
                BrandTrainingView(cat: cat)
            }
        }
        .buttonStyle(.borderless)
        
    }
    
}
