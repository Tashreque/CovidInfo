//
//  Endpoint.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 7/11/21.
//

import Foundation

/// The protocol each endpoint must conform to. This contains the basic elements that make up an HTTP request. Every rest endpoint that conforms to this protocol will have to implement these properties in a computed manner.
protocol Endpoint {
    /// HTTPS or HTTP (the protocol)
    var scheme: String { get }

    /// The base URL for the endpoint
    var baseUrl: String { get }

    /// The path to append to the base URL
    var path: String { get }

    /// URL query parameters
    var parameters: [URLQueryItem] { get }

    /// GET / POST / PUT etc.
    var method: String { get }
}
