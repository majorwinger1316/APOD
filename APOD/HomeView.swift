//
//  ContentView.swift
//  APOD
//
//  Created by Akshat Dutt Kaushik on 28/12/25.
//

import SwiftUI
import Photos

struct HomeView: View {
        @StateObject private var viewModel = HomeViewModel()

        @State private var selectedDate = Date()
        @State private var tempSelectedDate = Date()
        @State private var showDateSheet = false

        var body: some View {
            NavigationStack {
                content
                            .navigationTitle(
                                viewModel.apodList.first?.date ?? "APOD"
                            )
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
