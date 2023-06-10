//
//  WSRImageLoaderCachePolicy.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/10/23.
//

import UIKit

class WSRImageLoaderCachePolicy: ObservableObject {
    @Published var image: UIImage?
    @Published var invalidImage: Bool = false

    private var url: String
    private var task: URLSessionDataTask?

    init(url: String) {
        self.url = url
        loadImage()
    }

    private func loadImage() {
        if let cachedImage = WSRImageCache.shared.get(forKey: url) {
            self.image = cachedImage
            self.invalidImage = false
            return
        }

        guard let url = URL(string: url) else {
            self.invalidImage = true
            self.image = nil
            logger.error(message: "Invalid url error! \(self.url)")
            return
        }

        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.invalidImage = true
                    self.image = nil
                }
                logger.error(message: "Request error! \(self.url)")
                return
            }

            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                    self.invalidImage = false
                }
                
                WSRImageCache.shared.set(image, forKey: self.url)
                logger.log(category: .cache, message: self.url)
            }
            else {
                DispatchQueue.main.async {
                    self.invalidImage = true
                    self.image = nil
                }
                logger.error(message: "No image error! \(self.url)")
            }
        }
        task?.resume()
    }
}
