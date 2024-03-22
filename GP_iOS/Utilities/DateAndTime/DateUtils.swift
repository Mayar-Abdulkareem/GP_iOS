//
//  DateUtils.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 22/01/2024.
//

import Foundation

class DateUtils {
    static let shared = DateUtils()

    private init() {}

    private let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    private let outputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEEE, d MMMM yyyy, h:mm a"
        return formatter
    }()

    func convertToDate(date: String) -> String {
        if let date = isoFormatter.date(from: date) {
            let formattedDateString = outputFormatter.string(from: date)
            return formattedDateString
        } else {
            return ""
        }
    }

    func isAssignmentDue(dateString: String) -> Bool {
        guard let assignmentDueDate = isoFormatter.date(from: dateString) else {
            return true
        }

        let currentDate = Date()

        return currentDate > assignmentDueDate
    }
}
