//
//  CountryWise.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 7/11/21.
//

import Foundation

struct CountryWiseInfo: Codable {
    var updated: Int?
    var country: String?
    var countryInfo: CountryInfo?
    var cases, todayCases, deaths, todayDeaths: Int?
    var recovered, todayRecovered, active, critical: Int?
    var casesPerOneMillion, deathsPerOneMillion, tests, testsPerOneMillion: Int?
    var population: Int?
    var continent: String?
    var oneCasePerPeople, oneDeathPerPeople, oneTestPerPeople: Int?
    var activePerOneMillion, recoveredPerOneMillion, criticalPerOneMillion: Double?
}
