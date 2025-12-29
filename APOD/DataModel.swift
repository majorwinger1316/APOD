//
//  DataModel.swift
//  APOD
//
//  Created by Akshat Dutt Kaushik on 28/12/25.
//

import Foundation

struct ApodResponseData: Codable, Identifiable {
        let id = UUID()
        let date: String
        let explanation: String
        let hdurl: String?
        let mediaType: String
        let title: String
        let url: String

        enum CodingKeys: String, CodingKey {
                case date
                case explanation
                case hdurl
                case mediaType = "media_type"
                case title
                case url
        }
}

struct AlertMessage: Identifiable {
        let id = UUID()
        let message: String
}
