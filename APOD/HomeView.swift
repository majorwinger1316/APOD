//
//  ContentView.swift
//  APOD
//
//  Created by Akshat Dutt Kaushik on 28/12/25.
//

import SwiftUI

struct HomeView: View {
        @StateObject private var viewModel = HomeViewModel()

        @State private var selectedDate = Date()
        @State private var tempSelectedDate = Date()
        @State private var showDateSheet = false

        var body: some View {
            NavigationStack {
                content
                    .navigationTitle("APOD")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                tempSelectedDate = selectedDate
                                showDateSheet = true
                            } label: {
                                Image(systemName: "calendar")
                            }
                            .accessibilityLabel("Select Date")
                        }
                    }
                    .onAppear {
                        viewModel.fetchApod(for: selectedDate)
                    }
                    .sheet(isPresented: $showDateSheet) {
                        DatePickerSheet(
                            selectedDate: $tempSelectedDate,
                            onDone: {
                                selectedDate = tempSelectedDate
                                viewModel.fetchApod(for: selectedDate)
                                showDateSheet = false
                            },
                            onCancel: {
                                showDateSheet = false
                            }
                        )
                        .presentationDetents([.medium])
                    }
            }
        }
}

struct ApodCardView: View {

    let apod: ApodResponseData
        @State private var showFullScreen = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

                if apod.mediaType == "image",
                   let lowURL = URL(string: apod.url) {

                    ProgressiveImageView(
                        lowResURL: lowURL,
                        highResURL: URL(string: apod.hdurl ?? "")
                    )
                    .frame(height: 240)
                    .cornerRadius(14)
                }


            Text(apod.title)
                .font(.headline)

            Text(apod.date)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(apod.explanation)
                .font(.body)
                .lineLimit(5)

        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
        )
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

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

struct ExplanationView: View {

    let fullText: String
    let summaryText: String

    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text(expanded ? fullText : summaryText)
                .font(.body)
                .foregroundColor(.primary)
                .animation(.easeInOut, value: expanded)

            Button {
                expanded.toggle()
            } label: {
                Text(expanded ? "Show Less" : "Read More")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
        }
    }
}

struct ApodDatePicker: View {

    @Binding var selectedDate: Date

    private let apodStartDate = Calendar.current.date(
        from: DateComponents(year: 1995, month: 6, day: 16)
    )!

    var body: some View {
        DatePicker(
            "",
            selection: $selectedDate,
            in: apodStartDate...Date(),
            displayedComponents: [.date]
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
    }
}

struct DatePickerSheet: View {

    @Binding var selectedDate: Date
    let onDone: () -> Void
    let onCancel: () -> Void

    private let apodStartDate = Calendar.current.date(
        from: DateComponents(year: 1995, month: 6, day: 16)
    )!

    var body: some View {
        VStack(spacing: 0) {

            // Top Bar
            HStack {
                Button("Cancel") {
                    onCancel()
                }

                Spacer()

                Button("Done") {
                    onDone()
                }
                .fontWeight(.semibold)
            }
            .padding()
            .background(.ultraThinMaterial)

            Divider()

            // Clock-style wheel picker
            DatePicker(
                "",
                selection: $selectedDate,
                in: apodStartDate...Date(),
                displayedComponents: [.date]
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
        }
    }
}

struct ZoomableImageView: View {

    let imageURL: URL
    @Environment(\.dismiss) private var dismiss

    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(scale)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                scale = lastScale * value
                            }
                            .onEnded { _ in
                                lastScale = scale
                            }
                    )
                    .onTapGesture(count: 2) {
                        withAnimation {
                            scale = scale > 1 ? 1 : 2.5
                            lastScale = scale
                        }
                    }
            } placeholder: {
                ProgressView()
            }
        }
        .onTapGesture {
            dismiss()
        }
    }
}

extension String {
    func summarized() -> String {
        let sentences = self.split(separator: ".")
        return sentences.prefix(2).joined(separator: ". ") + "."
    }
}

private extension HomeView {

    @ViewBuilder
    var content: some View {
        if viewModel.isLoading {
            ProgressView()
                .padding()
        } else if let error = viewModel.errorMessage {
            Text(error)
                .foregroundColor(.red)
                .padding()
        } else {
            ScrollView {
                ForEach(viewModel.apodList) { apod in
                    ApodCardView(apod: apod)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
