//
//  CovidInfoEndpoint.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 7/11/21.
//

import Foundation

/// The endpoint enumeration which contains all the covid information related rest endpoint information in order to make an HTTP request.
enum CovidInfoEndpoint: Endpoint {
    // The API endpoint cases for covid information.
    case globalInformation(day: String = "")
    case informationOfAllCountries(day: String = "", sort: String = "")
    case countryWiseInformation(country: String, day: String = "")
    case continentWiseInformation(continent: String, day: String = "")

    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }

    var baseUrl: String {
        switch self {
        default:
            return "disease.sh"
        }
    }

    var path: String {
        switch self {
        case .globalInformation:
            return "/v3/covid-19/all"
        case .informationOfAllCountries:
            return "/v3/covid-19/countries"
        case .countryWiseInformation(let country, _):
            return "/v3/covid-19/countries/\(country)"
        case .continentWiseInformation(let continent, _):
            return "/v3/covid-19/continents/\(continent)"
        }
    }

    var parameters: [URLQueryItem] {
        let defaultQueryItem = URLQueryItem(name: "strict", value: "true")
        switch self {
        case .globalInformation(let day):
            return day.isEmpty ? [] : [URLQueryItem(name: day, value: day)]
        case .informationOfAllCountries(let day, let sort):
            var queryList = [URLQueryItem]()
            if !day.isEmpty {
                queryList.append(URLQueryItem(name: day, value: day))
            }
            if !sort.isEmpty {
                queryList.append(URLQueryItem(name: sort, value: sort))
            }
            return queryList
        case .countryWiseInformation(_, let day):
            return day.isEmpty ? [defaultQueryItem] : [URLQueryItem(name: day, value: day), defaultQueryItem]
        case .continentWiseInformation(_, let day):
            return day.isEmpty ? [defaultQueryItem] : [URLQueryItem(name: day, value: day), defaultQueryItem]
        }
    }

    var method: String {
        switch self {
        default:
            return "GET"
        }
    }
}

