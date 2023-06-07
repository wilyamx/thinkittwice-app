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
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.image = image
                WSRImageCache.shared.set(image!, forKey: self.url)
            }
        }
        task?.resume()
    }
}
