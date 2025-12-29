//
//  ApodError.swift
//  APOD
//
//  Created by Akshat Dutt Kaushik on 29/12/25.
//

import Foundation

enum ApodError: LocalizedError, Identifiable {
        case network
        case invalidResponse
        case invalidDate
        case missingMedia

        var id: String { localizedDescription }

        var errorDescription: String? {
                switch self {
                case .network:
                        return "Network connection failed. Please check your internet."
                case .invalidResponse:
                        return "Received invalid data from NASA."
                case .invalidDate:
                        return "Selected date is not supported."
                case .missingMedia:
                        return "This APOD does not contain an image."
                }
        }
}
