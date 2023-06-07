//
//  WSRImageCache.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/7/23.
//

import UIKit

/**
    https://xavier7t.com/image-caching-in-swiftui
 */
class WSRImageCache {
    static let shared = WSRImageCache()

    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}
