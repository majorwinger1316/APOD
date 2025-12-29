//
//  ProgressiveImageLoader.swift
//  APOD
//
//  Created by Akshat Dutt Kaushik on 29/12/25.
//


import UIKit

final class ProgressiveImageLoader {

    static let shared = ProgressiveImageLoader()

    private init() {}

    func loadImage(
        lowResURL: URL,
        highResURL: URL?,
        completion: @escaping (UIImage) -> Void
    ) {

        if let highResURL = highResURL,
           let cachedHD = ImageCache.shared.image(forKey: highResURL.absoluteString) {
            completion(cachedHD)
            return
        }

        if let cachedLow = ImageCache.shared.image(forKey: lowResURL.absoluteString) {
            completion(cachedLow)
        } else {
            downloadImage(from: lowResURL) { image in
                ImageCache.shared.set(image, forKey: lowResURL.absoluteString)
                completion(image)
            }
        }

        guard let highResURL = highResURL else { return }

        downloadImage(from: highResURL) { image in
            ImageCache.shared.set(image, forKey: highResURL.absoluteString)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }

    private func downloadImage(
        from url: URL,
        completion: @escaping (UIImage) -> Void
    ) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            completion(image)
        }.resume()
    }
}
