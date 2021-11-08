//
//  CountryInfo.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 8/11/21.
//

import Foundation

struct CountryInfo: Codable {
    var id: Int?
    var iso2, iso3: String?
    var lat, long: Double?
    var flag: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case iso2, iso3, lat, long, flag
    }
}

