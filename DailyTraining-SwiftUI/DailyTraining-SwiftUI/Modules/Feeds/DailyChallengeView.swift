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
                    Text(LocalizedStringKey(String.daily_challenge))
                        .fontWeight(.bold)
                    
                    Text("\(cat.name): \(cat.temperament)")
                        .lineLimit(1)
                }
            }
            .padding(.top)
            
            Button(action: {
                logger.info(message: "Take the challenge! \(cat.name)")
            },
                   label: {
                Text(String.take_the_challenge.localizedString().uppercased())
                    .wsr_ButtonLabel(bgColor: .black, fgColor: .white, font: .footnote.bold())
            })
            .cornerRadius(10)
            .padding(.bottom)
        }
    }
    
}

struct DailyChallengeView_Previews: PreviewProvider {
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
                    DailyChallengeView(cat: cat)
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
        .environment(\.locale, .init(identifier: "fr"))
    }
}
