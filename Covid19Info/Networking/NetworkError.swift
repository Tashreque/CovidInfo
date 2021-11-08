//
//  NetworkError.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 7/11/21.
//

import Foundation

//
//  NetworkError.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 7/10/21.
//

import Foundation

enum NetworkError: Error {
    case badStatusCode(code: Int)
    case badData
    case badResponse
    case failedDataParsing
    case failedRequest
    case badUrl

    var errorMessage: String {
        switch self {
        case .badStatusCode(let code):
            return "Bad status of response: \(code)"
        case .badData:
            return "Bad data!"
        case .badResponse:
            return "Bad response!"
        case .failedDataParsing:
            return "Failed to parse data!"
        case .failedRequest:
            return "The request failed!"
        case .badUrl:
            return "Bad URL!"
        }
    }
}

