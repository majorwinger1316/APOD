//
//  ZoomableImageView.swift
//  APOD
//
//  Created by Akshat Dutt Kaushik on 29/12/25.
//

import SwiftUI
import Photos

struct ZoomableImageView: View {

    let imageURL: URL
    let title: String?
    let date: String?

    @Environment(\.dismiss) private var dismiss

    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1
    @State private var dragOffset: CGFloat = 0
    @State private var alertMessage: AlertMessage?

    private let minScale: CGFloat = 1
    private let maxScale: CGFloat = 5

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            GeometryReader { geo in
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    ZStack {
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(scale)
                                .frame(
                                    width: geo.size.width,
                                    height: geo.size.height
                                )
                                .gesture(
                                    MagnificationGesture()
                                        .onChanged { value in
                                            let newScale = lastScale * value
                                            scale = min(max(newScale, minScale), maxScale)
                                        }
                                        .onEnded { _ in
                                            lastScale = scale
                                        }
                                )
                                .onTapGesture(count: 2) {
                                    withAnimation(.easeInOut) {
                                        scale = scale > 1 ? 1 : 2.5
                                        lastScale = scale
                                    }
                                }
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    .frame(
                        width: geo.size.width,
                        height: geo.size.height
                    )
                }
            }

            // Header + Actions
            VStack {
                header
                Spacer()
            }
        }
        .alert(item: $alertMessage) { alert in
            Alert(
                title: Text("Photo"),
                message: Text(alert.message),
                dismissButton: .default(Text("OK"))
            )
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation.height
                }
                .onEnded { _ in
                    if dragOffset > 120 {
                        dismiss()
                    }
                    dragOffset = 0
                }
        )
    }
}

private extension ZoomableImageView {

    var header: some View {
        VStack(spacing: 8) {

            Capsule()
                .fill(Color.white.opacity(0.35))
                .frame(width: 40, height: 5)
                .padding(.top, 8)

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    if let title {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(1)
                    }

                    if let date {
                        Text(date)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }

                Spacer()

                HStack(spacing: 12) {

                    Button {
                        saveImage()
                    } label: {
                        Image(systemName: "arrow.down.to.line")
                    }

                    Button {
                        shareImage()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primary)
                .padding(10)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
            }
            .padding(.horizontal)
        }
        .background(
            LinearGradient(
                colors: [Color.black.opacity(0.85), Color.black.opacity(0.0)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

private extension ZoomableImageView {

        func saveImage() {
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: imageURL)
                    guard let image = UIImage(data: data) else {
                        alertMessage = AlertMessage(message: "Failed to decode image")
                        return
                    }

                    try await saveToPhotos(image)
                    alertMessage = AlertMessage(message: "Saved to Photos")

                } catch {
                    alertMessage = AlertMessage(message: "Failed to save image")
                }
            }
        }

        func saveToPhotos(_ image: UIImage) async throws {
            let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)

            switch status {
            case .authorized, .limited:
                try await writeImage(image)

            case .notDetermined:
                let newStatus = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
                guard newStatus == .authorized || newStatus == .limited else {
                    throw NSError()
                }
                try await writeImage(image)

            default:
                throw NSError()
            }
        }

        func writeImage(_ image: UIImage) async throws {
            try await PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
        }


        func shareImage() {
            DispatchQueue.main.async {
                let activityVC = UIActivityViewController(
                    activityItems: [imageURL],
                    applicationActivities: nil
                )

                guard
                    let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let root = scene.windows.first?.rootViewController
                else { return }

                var topController = root
                while let presented = topController.presentedViewController {
                    topController = presented
                }

                topController.present(activityVC, animated: true)
            }
        }
}
