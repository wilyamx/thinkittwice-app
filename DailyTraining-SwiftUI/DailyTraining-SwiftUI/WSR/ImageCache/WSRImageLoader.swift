//
//  WSRImageLoader.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/7/23.
//

import Foundation
import UIKit

/**
    https://xavier7t.com/image-caching-in-swiftui
 */
class WSRImageLoader: ObservableObject {
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
            return
        }

        guard let url = URL(string: url) else { return }

        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.invalidImage = true
                    self.image = nil
                }
                logger.error(message: "Image-1 cache error! \(self.url)")
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
                logger.error(message: "Image-2 cache error! \(self.url)")
            }
        }
        task?.resume()
    }
}
