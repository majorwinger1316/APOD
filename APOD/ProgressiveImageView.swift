//
//  ProgressiveImageView.swift
//  APOD
//
//  Created by Akshat Dutt Kaushik on 29/12/25.
//

import SwiftUI

struct ProgressiveImageView: View {

    let lowResURL: URL
    let highResURL: URL?

    @State private var image: UIImage?

    var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .transition(.opacity)
            } else {
                ProgressView()
            }
        }
        .clipped()
        .onAppear {
            ProgressiveImageLoader.shared.loadImage(
                lowResURL: lowResURL,
                highResURL: highResURL
            ) { loadedImage in
                withAnimation(.easeInOut(duration: 0.25)) {
                    image = loadedImage
                }
            }
        }
    }
}
