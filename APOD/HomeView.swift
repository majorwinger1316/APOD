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
                        .presentationDragIndicator(.visible)
                        .presentationBackground(.clear)
                    }
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
