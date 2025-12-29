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

        @State private var swipeOffset: CGFloat = 0
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
        
        private let apodStartDate = Calendar.current.date(
            from: DateComponents(year: 1995, month: 6, day: 16)
        )!
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

            } else if viewModel.showNotPublishedMessage {
                VStack(spacing: 16) {
                    Image(systemName: "clock")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)

                    Text("Today's APOD is not published yet")
                        .font(.headline)

                    Text("NASA usually publishes the Astronomy Picture of the Day later in the day. Please check back soon.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)

                    Button {
                        viewModel.retry(selectedDate: selectedDate)
                    } label: {
                        Label("Retry", systemImage: "arrow.clockwise")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()

            } else if let error = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Text(error)
                        .foregroundColor(.red)

                    Button("Retry") {
                        viewModel.retry(selectedDate: selectedDate)
                    }
                }
                .padding()

            } else {
                ScrollView {
                    ForEach(viewModel.apodList) { apod in
                        ApodCardView(apod: apod)
                    }
                }
                .offset(x: swipeOffset)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 20)
                        .onChanged { value in
                            if abs(value.translation.width) > abs(value.translation.height) {
                                swipeOffset = value.translation.width * 0.25
                            }
                        }
                        .onEnded { value in
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                swipeOffset = 0
                            }
                            handleSwipe(value)
                        }
                )
        }
    }
        
        private func handleSwipe(_ value: DragGesture.Value) {
            let horizontal = value.translation.width
            let vertical = value.translation.height
                
            guard abs(horizontal) > abs(vertical) else { return }

            guard abs(horizontal) > 80 else { return }

            if horizontal < 0 {
                    moveToNextDay()
            } else {
                    moveToPreviousDay()
            }
        }


        private func moveToPreviousDay() {
            guard let newDate = Calendar.current.date(
                byAdding: .day,
                value: -1,
                to: selectedDate
            ),
            newDate >= apodStartDate
            else { return }

            withAnimation(.easeInOut) {
                selectedDate = newDate
                viewModel.fetchApod(for: selectedDate)
            }
                
                triggerHaptic()
        }

        private func moveToNextDay() {
            guard let newDate = Calendar.current.date(
                byAdding: .day,
                value: 1,
                to: selectedDate
            ),
            newDate <= Date()
            else { return }

            withAnimation(.easeInOut) {
                selectedDate = newDate
                viewModel.fetchApod(for: selectedDate)
            }
                
                triggerHaptic()
        }
        
        private func triggerHaptic() {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }

}

#Preview {
    HomeView()
}
