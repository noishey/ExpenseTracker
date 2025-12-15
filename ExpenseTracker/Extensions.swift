//
//  Extensions.swift
//  ExpenseTracker
//
//  Created by Arjun Shenoy on 16/11/25.
//

import Foundation
import SwiftUI

extension Color {
    // Use unique names to avoid collisions with other APIs or extensions.
    static let appBackground = Color("Background")
    static let appText = Color("Text")
    static let appIcon = Color("Icon")
    static let systemBackground = Color(uiColor: .systemBackground)
}

extension DateFormatter{
    static let allNumericUSA: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
}

extension String {
    func dateParsed() -> Date {
        guard let parsedDate = DateFormatter.allNumericUSA.date(from: self) else {
            return Date()
        }
        return parsedDate
    }
}
