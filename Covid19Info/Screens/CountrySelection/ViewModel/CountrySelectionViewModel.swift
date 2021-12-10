//
//  CountrySelectionViewModel.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 10/12/21.
//

import Foundation

class CountrySelectionViewModel {
    var shouldUpdateCountryList: (() -> ())?
    var countryList = [String]() {
        didSet {
            shouldUpdateCountryList?()
        }
    }

    var flagUrls = [String]()

    private var originalCountryList = [String]()
    private var originalFlagUrls = [String]()
    private var countryAndIconDictionary = [String : String]()

    func setCountryList(countries: [String], flagUrlList: [String]) {
        originalCountryList = countries
        countryList = originalCountryList
        flagUrls = flagUrlList
        originalFlagUrls = flagUrls

        for (i, country) in countryList.enumerated() {
            countryAndIconDictionary[country] = flagUrls[i]
        }
    }

    func filterCountries(searchText: String) {
        if searchText.isEmpty {
            // Reset country list and icon url list.
            countryList = originalCountryList
            flagUrls = originalFlagUrls
        } else {
            // Filter country names.
            countryList = originalCountryList.filter({ country in
                let lowerCasedSearchText = searchText.lowercased()
                return country.lowercased().contains(lowerCasedSearchText)
            })

            // Filter flag urls.
            flagUrls = []
            for country in countryList {
                flagUrls.append(countryAndIconDictionary[country] ?? "")
            }
        }
    }
}
