//
//  DateFormatter.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/16/24.
//

import Foundation

struct DateFormatter {
    let formatter: ISO8601DateFormatter
    static let shared = DateFormatter()

    private init() {
        formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withFractionalSeconds,
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withColonSeparatorInTime,
            .withColonSeparatorInTimeZone
        ]
    }
}
