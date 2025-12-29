//
//  ExplanationView.swift
//  APOD
//
//  Created by Akshat Dutt Kaushik on 29/12/25.
//

import SwiftUI

struct ExplanationView: View {

    let text: String
    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text(text)
                .font(.body)
                .lineLimit(expanded ? nil : 4)
                .animation(.easeInOut, value: expanded)

            Button {
                expanded.toggle()
            } label: {
                Text(expanded ? "Show Less" : "Read Full Explanation")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
        }
    }
}
