//
//  DailyChallengeView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/6/23.
//

import SwiftUI

struct DailyChallengeView: View {
    var cat: Cat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                ZStack {
                    Circle()
                        .foregroundColor(ColorNames.listBackgroundColor.colorValue)
                    Image(systemName: "bolt")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                        .font(.system(size: 30))
                }
                .frame(height: 50)
                .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text("Daily Challenge")
                        .fontWeight(.bold)
                    
                    Text("\(cat.name): \(cat.temperament)")
                        .lineLimit(1)
                }
            }
            
            Button(action: {
                logger.info(message: "Take the challenge! \(cat.name)")
            },
                   label: {
                Text("TAKE THE CHALLENGE")
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

struct DailyChallengeView_Previews: PreviewProvider {
    /**
        https://www.mongodb.com/docs/realm/sdk/swift/swiftui/swiftui-previews/
     */
    static var previews: some View {
        List {
            let realm = WSRMockRealms.previewRealm
            let cats = realm.objects(Cat.self)
            
            if let cat = cats.first {
                DailyChallengeView(cat: cat)
            }
        }
    }
}
