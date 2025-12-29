//
//  ShareSheet.swift
//  APOD
//
//  Created by Akshat Dutt Kaushik on 29/12/25.
//


import UIKit
import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {

    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
