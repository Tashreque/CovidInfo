//
//  NetworkManager.swift
//  Covid19Info
//
//  Created by Tashreque Mohammed Haq on 7/11/21.
//

import Foundation

class NetworkManager {

    // The single one time only instance of this class.
    static let shared = NetworkManager()

    // The initializer made private so that this class cannot be instantiated.
    private init() {}

    // The singleton instance of URLSession.
    private let session = URLSession.shared

    func getRequest<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> ()) {
        // Setup a URLComponents object based on the properties of the endpoint.
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.queryItems = endpoint.parameters
        components.host = endpoint.baseUrl
        components.path = endpoint.path

        // Construct URL from the URLComponents instance.
        guard let url = components.url else {
            completion(.failure(.badUrl))
            return
        }
        print("URL is \(url.absoluteString)")

        // Create the URL request object.
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method

        // Create a data task from the URLSession object. Within the response closure, the response, error and data are handled.
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(.failedRequest))
                print(error?.localizedDescription ?? "Unknown error!")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Wrong response type!")
                completion(.failure(.badResponse))
                return
            }

            let statusCode = httpResponse.statusCode
            guard (200...299).contains(statusCode) else {
                print("Error status code: \(httpResponse.statusCode)")
                completion(.failure(.badStatusCode(code: statusCode)))
                return
            }

            guard let data = data else {
                print("Bad data!")
                completion(.failure(.badData))
                return
            }

            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data)
                print("Successfully parsed response object!")
                completion(.success(responseObject))
            } catch {
                debugPrint(error)
                completion(.failure(.failedDataParsing))
            }
        }
        dataTask.resume()
    }
}
