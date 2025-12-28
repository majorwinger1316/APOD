//
//  HomeViewModel.swift
//  APOD
//
//  Created by Akshat Dutt Kaushik on 28/12/25.
//

import SwiftUI
import Foundation
internal import Combine

@MainActor
final class HomeViewModel: ObservableObject {

    @Published var apodList: [ApodResponseData] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var lastFetchedDate: String?

    private var apiKey: String {
        Bundle.main.object(
            forInfoDictionaryKey: "API_KEY"
        ) as? String ?? ""
    }

    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()

    // MARK: - Public API
    func fetchApod(for date: Date) {
        let dateString = dateFormatter.string(from: date)
        guard dateString != lastFetchedDate else { return }
        lastFetchedDate = dateString

        fetchApod(date: dateString)
    }

    // MARK: - Network
    private func fetchApod(date: String) {
        guard let url = buildURL(date: date) else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoded = try JSONDecoder().decode(ApodResponseData.self, from: data)

                withAnimation(.easeInOut(duration: 0.35)) {
                    self.apodList = [decoded]
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }

            self.isLoading = false
        }
    }

    // MARK: - URL Builder
    private func buildURL(date: String) -> URL? {
        var components = URLComponents(string: EndPoint.apod)
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "date", value: date)
        ]
        return components?.url
    }
}

private extension HomeViewModel {
        func buildURL(
            date: String?,
            startDate: String?,
            endDate: String?,
            count: Int?,
            thumbs: Bool
        ) -> URL? {
            
                var components = URLComponents(string: EndPoint.apod)
                var queryItems: [URLQueryItem] = [
                        URLQueryItem(name: "api_key", value: apiKey)
                ]
                
                if let date = date {
                        queryItems.append(URLQueryItem(name: "date", value: date))
                }
                
                if let startDate = startDate {
                    queryItems.append(URLQueryItem(name: "start_date", value: startDate))
                }

                if let endDate = endDate {
                    queryItems.append(URLQueryItem(name: "end_date", value: endDate))
                }

                if let count = count {
                    queryItems.append(URLQueryItem(name: "count", value: "\(count)"))
                }

                if thumbs {
                    queryItems.append(URLQueryItem(name: "thumbs", value: "true"))
                }

                components?.queryItems = queryItems
                return components?.url
        }
}

