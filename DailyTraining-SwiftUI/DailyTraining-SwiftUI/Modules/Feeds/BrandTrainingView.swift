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
                .padding(.top)
                                    
            WSRWebImage(url: cat.imageUrl())
                .frame(width: UIScreen.main.bounds.width - 40, height: 200)
                .foregroundColor(Color.white)
                .background(Color.secondary.opacity(0.5))
                .cornerRadius(15)
                .clipped()
            
            Text(cat.breedExplanation)
                .lineLimit(4)
            
            Button(action: {
                logger.info(message: "Take the course! \(cat.name) (\(cat.referenceImageId).jpg)")
                logger.info(message: "\(cat.breedExplanation)")
            },
                   label: {
                Text("TAKE THE COURSE")
                    .wsr_ButtonLabel(bgColor: .black, fgColor: .white, font: .footnote.bold())
            })
            .padding(.bottom)
        }
    }
}

struct BrandTrainingView_Previews: PreviewProvider {
    /**
        https://www.mongodb.com/docs/realm/sdk/swift/swiftui/swiftui-previews/
     */
    static var previews: some View {
        List {
            let realm = MockRealms.previewRealm
            let cats = realm.objects(Cat.self)
            let rowSpacing: CGFloat = 10.0
            
            if let cat = cats.first {
                Group {
                    BrandTrainingView(cat: cat)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 15)
                        .padding(EdgeInsets(top: rowSpacing,
                                            leading: rowSpacing,
                                            bottom: rowSpacing,
                                            trailing: rowSpacing))
                        .background(.clear)
                        .foregroundColor(.white)
                )
            }
        }
        .listStyle(.plain)
        .background(ColorNames.listBackgroundColor.colorValue)
        .buttonStyle(.borderless)
        
    }
    
}
