//
//  Date+Extensions.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 30/12/21.
//

import Foundation

extension Date {
    func getDateString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = .autoupdatingCurrent
        formatter.locale = .autoupdatingCurrent
        return formatter.string(from: self)
    }
}
