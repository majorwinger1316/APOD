//
//  ExplanationView.swift
//  APOD
//
//  Created by Akshat Dutt Kaushik on 29/12/25.
//

import SwiftUI

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
