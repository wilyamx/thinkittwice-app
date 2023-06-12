//
//  NewsView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/6/23.
//

import SwiftUI

struct NewsView: View {
    var cat: Cat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            WSRWebImage(url: cat.imageUrl())
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        Text("MARKET NEWS")
                            .fontWeight(.bold)
                            .padding([.top, .leading])

                        Spacer()

                        Text(cat.altNames)
                            .lineLimit(4)
                            .padding([.leading, .trailing, .bottom])
                    }
                }
                .foregroundColor(Color.white)
                .background(Color.secondary.opacity(0.5))
                .clipped()
                .cornerRadius(15)
                        
            HStack {
                HStack(spacing: 20) {
                    HStack(spacing: 0) {
                        Image(systemName: "heart")
                        Text("12")
                            .fontWeight(.bold)
                    }
                    
                    HStack(spacing: 0) {
                        Image(systemName: "bubble.left")
                        Text("223")
                            .fontWeight(.bold)
                    }
                }
                
                Spacer()
                
                Text("JAN 1ST")
                    .foregroundColor(Color.gray)
            }
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    /**
        https://www.mongodb.com/docs/realm/sdk/swift/swiftui/swiftui-previews/
     */
    static var previews: some View {
        List {
            let realm = WSRMockRealms.previewRealm
            let cats = realm.objects(Cat.self)
            
            if let cat = cats.first {
                NewsView(cat: cat)
            }
        }
    }
}
