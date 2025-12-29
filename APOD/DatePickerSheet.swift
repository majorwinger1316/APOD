//
//  DatePickerSheet.swift
//  APOD
//
//  Created by Akshat Dutt Kaushik on 29/12/25.
//

import SwiftUI

struct DatePickerSheet: View {

    @Binding var selectedDate: Date
    let onDone: () -> Void
    let onCancel: () -> Void

    private let apodStartDate = Calendar.current.date(
        from: DateComponents(year: 1995, month: 6, day: 16)
    )!

    var body: some View {
        VStack(spacing: 0) {

                HStack {
                    Button("Cancel") {
                        onCancel()
                    }

                    Spacer()

                    Button("Done") {
                        onDone()
                    }
                    .fontWeight(.semibold)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 4)
                .background(Color.clear)


            Divider()

            // Clock-style wheel picker
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
}
