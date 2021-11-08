//
//  Summary.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 7/11/21.
//

import Foundation

struct Summary: Codable {
    var updated, cases, todayCases, deaths: Int?
    var todayDeaths, recovered, todayRecovered, active: Int?
    var critical, casesPerOneMillion: Int?
    var deathsPerOneMillion: Double?
    var tests: Int?
    var testsPerOneMillion: Double?
    var population, oneCasePerPeople, oneDeathPerPeople, oneTestPerPeople: Int?
    var activePerOneMillion, recoveredPerOneMillion, criticalPerOneMillion: Double?
    var affectedCountries: Int?
}
