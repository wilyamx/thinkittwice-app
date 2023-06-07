//
//  WSRRemoteImage.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/7/23.
//

import SwiftUI

/**
    https://xavier7t.com/image-caching-in-swiftui
 */
struct WSRRemoteImage: View {
    @ObservedObject var imageLoader: WSRImageLoader
    
    init(url: String) {
        imageLoader = WSRImageLoader(url: url)
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

struct WSRRemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        WSRRemoteImage(url: "https://cdn2.thecatapi.com/images/unX21IBVB.jpg")
            .frame(height: 200)
            .clipped()
            .padding()
    }
}
