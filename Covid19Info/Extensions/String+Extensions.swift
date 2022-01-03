//
//  String+Extensions.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 30/12/21.
//

import Foundation

extension String {
    func getDate(stringFormat: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = stringFormat
        formatter.timeZone = .autoupdatingCurrent
        formatter.locale = .autoupdatingCurrent
        return formatter.date(from: self) ?? Date()
    }
}
