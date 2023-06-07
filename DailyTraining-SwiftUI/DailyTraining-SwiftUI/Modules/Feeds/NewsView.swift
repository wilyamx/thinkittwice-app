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
            AsyncImage(url: URL(string: "https://cdn2.thecatapi.com/images/\(Cat.refereceImageId()).jpg")) { phase in
                if let image = phase.image {
                    // displays the loaded image
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .cornerRadius(15)
                        .clipped()
                        .overlay(alignment: .topLeading) {
                            VStack(alignment: .leading) {
                                Text("MARKET NEWS")
                                    .fontWeight(.bold)
                                    .padding([.top, .leading])
                                
                                Spacer()
                                
                                Text(cat.temperament)
                                    .lineLimit(4)
                                    .padding([.leading, .trailing, .bottom])
                            }
                        }
                        .foregroundColor(Color.white)
                }
                else if phase.error != nil {
                    // indicates an error
                    Color.red
                }
                else {
                    // acts as a placeholder
                    Color.blue
                }
            }
            
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
                
                Text("FEB 18TH")
                    .foregroundColor(Color.gray)
            }
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            NewsView(cat: Cat.example())
        }
    }
}
