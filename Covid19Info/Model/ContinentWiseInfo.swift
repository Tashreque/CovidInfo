//
//  ContinentWiseInfo.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 7/11/21.
//

import Foundation

struct ContinentWiseInfo: Codable {
    var updated, cases, todayCases, deaths: Int?
    var todayDeaths, recovered, todayRecovered, active: Int?
    var critical: Int?
    var casesPerOneMillion, deathsPerOneMillion: Double?
    var tests: Int?
    var testsPerOneMillion: Double?
    var population: Int?
    var continent: String?
    var activePerOneMillion, recoveredPerOneMillion, criticalPerOneMillion: Double?
    var continentInfo: ContinentInfo?
    var countries: [String]?
}
