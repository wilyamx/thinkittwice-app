//
//  WSRWebImage.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/10/23.
//

import SwiftUI

/**
     Cache using policy
 
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
 */
struct WSRWebImage: View {
    @ObservedObject var imageLoader: WSRImageLoaderCachePolicy
    
    init(url: String) {
        imageLoader = WSRImageLoaderCachePolicy(url: url)
    }
    
    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            if imageLoader.invalidImage {
                Image(systemName: "x.circle")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
            }
            else {
                ProgressView()
                    .scaleEffect(2)
            }
        }
    }
}

struct WSRWebImage_Previews: PreviewProvider {
    static var previews: some View {
        WSRRemoteImage(url: "https://cdn2.thecatapi.com/images/unX21IBVB.jpg")
            .frame(height: 200)
            .clipped()
            .padding()
    }
}
