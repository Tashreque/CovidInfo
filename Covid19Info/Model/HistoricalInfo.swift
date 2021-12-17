//
//  HistoricalInfo.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 17/12/21.
//

import Foundation

struct HistoricalInfo: Codable {
    let cases: [String : Int]?
    let deaths: [String : Int]?
    let recovered: [String : Int]?
}
