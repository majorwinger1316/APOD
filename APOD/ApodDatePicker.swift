//
//  ApodDatePicker.swift
//  APOD
//
//  Created by Akshat Dutt Kaushik on 29/12/25.
//

import SwiftUI

struct ApodDatePicker: View {

    @Binding var selectedDate: Date

    private let apodStartDate = Calendar.current.date(
        from: DateComponents(year: 1995, month: 6, day: 16)
    )!

    var body: some View {
        DatePicker(
            "",
            selection: $selectedDate,
            in: apodStartDate...Date(),
            displayedComponents: [.date]
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
    }
}
