//
//  ImageCache.swift
//  APOD
//
//  Created by Akshat Dutt Kaushik on 29/12/25.
//


import UIKit

final class ImageCache {

    static let shared = ImageCache()
    private let memoryCache = NSCache<NSString, UIImage>()

    private init() {}

    func image(forKey key: String) -> UIImage? {
        memoryCache.object(forKey: key as NSString)
    }

    func set(_ image: UIImage, forKey key: String) {
        memoryCache.setObject(image, forKey: key as NSString)
    }
}
