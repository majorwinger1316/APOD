//
//  HomeViewModel.swift
//  APOD
//
//  Created by Akshat Dutt Kaushik on 28/12/25.
//

import SwiftUI
import Foundation
internal import Combine

final class HomeViewModel: ObservableObject {
    
        @Published var apodList: [ApodResponseData] = []
        @Published var isLoading = false
        @Published var errorMessage: String?
    
        private var apiKey: String {
                Bundle.main.object(
                        forInfoDictionaryKey: "API_KEY"
                ) as? String ?? ""
        }
    
        func fetchApod(
                date: String? = nil,
                startDate: String? = nil,
                endDate: String? = nil,
                count: Int? = nil,
                thumbs: Bool = false
                ) {
                guard let url = buildURL(
                        date: date,
                        startDate: startDate,
                        endDate: endDate,
                        count: count,
                        thumbs: thumbs
                ) else {
                        errorMessage = "Invalid URL"
                        return
                }
        
                isLoading = true
                errorMessage = nil
        
                URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                        DispatchQueue.main.async {
                                self?.isLoading = false
                        }
            
                        if let error = error {
                                DispatchQueue.main.async {
                                        self?.errorMessage = error.localizedDescription
                                }
                                return
                        }
            
                        guard let data = data else {
                                DispatchQueue.main.async {
                                        self?.errorMessage = "No data received"
                                }
                            return
                        }
            
                        do {
                                let decoder = JSONDecoder()
                
                                if let list = try? decoder.decode([ApodResponseData].self, from: data) {
                                        DispatchQueue.main.async {
                                                self?.apodList = list
                                        }
                                } else {
                                        let single = try decoder.decode(ApodResponseData.self, from: data)
                                        DispatchQueue.main.async {
                                                self?.apodList = [single]
                                        }
                                }
                        } catch {
                                DispatchQueue.main.async {
                                        self?.errorMessage = "Decoding error: \(error.localizedDescription)"
                                }
                        }
                }.resume()
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
