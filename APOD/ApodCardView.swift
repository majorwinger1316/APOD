//
//  ApodCardView.swift
//  APOD
//
//  Created by Akshat Dutt Kaushik on 29/12/25.
//

import SwiftUI
import UIKit

struct ApodCardView: View {

        let apod: ApodResponseData

        @State private var showFullScreen = false
        @State private var showShareSheet = false
        @State private var isSaving = false
        @State private var alertMessage: AlertMessage?

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            // MARK: - Image Section
                ZStack(alignment: .topTrailing) {
                        
                        if apod.mediaType == "image",
                           let lowURL = URL(string: apod.url) {
                                
                                ProgressiveImageView(
                                        lowResURL: lowURL,
                                        highResURL: URL(string: apod.hdurl ?? "")
                                )
                                .frame(height: 260)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .onTapGesture {
                                        showFullScreen = true
                                }
                        } else {
                                Text("No image available")
                                        .foregroundColor(.secondary)
                                        .frame(height: 260)
                        }
                        
                        // MARK: - Action Buttons
                        HStack(spacing: 12) {
                                
                                VStack(spacing: 10) {
                                        
                                        Button {
                                                saveImage()
                                        } label: {
                                                Image(systemName: "arrow.down.to.line")
                                        }
                                        
                                        Button {
                                                showShareSheet = true
                                        } label: {
                                                Image(systemName: "square.and.arrow.up")
                                        }
                                        
                                }
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .padding(12)
                                
                        }
                }

            // MARK: - Text Content
            VStack(alignment: .leading, spacing: 6) {

                Text(apod.title)
                    .font(.title3)
                    .fontWeight(.semibold)

                Text(apod.date)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(apod.explanation.summarized())
                    .font(.body)
                    .foregroundColor(.primary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.15))
        )
        .padding(.horizontal)
        .padding(.top, 12)
        .fullScreenCover(isPresented: $showFullScreen) {
            if let url = URL(string: apod.hdurl ?? apod.url) {
                ZoomableImageView(imageURL: url)
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [URL(string: apod.url)!])
        }
        .alert(item: $alertMessage) { alert in
            Alert(
                title: Text("Photo"),
                message: Text(alert.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }

        private func saveImage() {
            guard let url = URL(string: apod.hdurl ?? apod.url) else {
                alertMessage = AlertMessage(message: "Invalid image URL")
                return
            }

            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    guard let image = UIImage(data: data) else {
                        alertMessage = AlertMessage(message: "Failed to decode image")
                        return
                    }

                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    alertMessage = AlertMessage(message: "Saved to Photos")
                } catch {
                    alertMessage = AlertMessage(message: "Failed to save image")
                }
            }
        }
}
