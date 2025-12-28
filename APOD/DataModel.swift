//
//  DataModel.swift
//  APOD
//
//  Created by Akshat Dutt Kaushik on 28/12/25.
//

import Foundation

struct ApodData: Codable {
    let date: String
    let explanation: String
    let hdurl: String
    let media_type: String
    let title: String
    let url: String
}
