//
//  Extensions.swift
//  Gazebo
//
//  Created by Nicholas Vanhaute on 8/16/24.
//

import Foundation

extension TimeInterval {
    static let fiveMinutes = TimeInterval(5 * 60)
}

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
