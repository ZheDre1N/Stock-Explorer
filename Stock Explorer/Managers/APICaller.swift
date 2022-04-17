//
//  APICaller.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 17.04.2022.
//

import Foundation

/// Object to manage API Calls
final class APICaller {
  /// Singleton
  public static let shared = APICaller()
  private init() {}

  // MARK: Public
  public func marketData(
    for symbol: String,
    numberOfDays: TimeInterval = 3000,
    completion: @escaping(Result<MarketDataResponse, Error>) -> Void
  ) {
    let today = Date().addingTimeInterval(-(3600 * 24))
    let prior = today.addingTimeInterval(-(3600 * 24 * numberOfDays))

    let url = url(
      for: .marketData,
      queryParams: [
        "symbol": symbol,
        "resolution": "60",
        "from": "\(Int(prior.timeIntervalSince1970))",
        "to": "\(Int(today.timeIntervalSince1970))"
      ]
    )

    request(url: url, expecting: MarketDataResponse.self, completion: completion)
  }

  // MARK: Private
  private enum Constants {
    static let apiKey = "c95b8gqad3icae7g81cg"
    static let sandboxAPIKey = "sandbox_c95b8gqad3icae7g81d0"
    static let baseURL = "https://finnhub.io/api/v1/"
  }

  private enum Endpoint: String {
    case marketData = "stock/candle"
  }

  private enum APIError: Error {
    case invalidURL
    case noDataReturned
  }

  private func url(for endpoint: Endpoint, queryParams: [String: String] = [:]) -> URL? {
    var urlString = Constants.baseURL + endpoint.rawValue
    var queryItems = [URLQueryItem]()
    // add any params
    for (name, value) in queryParams {
      queryItems.append(.init(name: name, value: value))
    }

    // add token
    queryItems.append(.init(name: "token", value: Constants.apiKey))

    // Convert queri items to suffix string
    urlString += "?" + queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")

    return URL(string: urlString)
  }

  private func request<T: Codable>(url: URL?, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
    guard let url = url else {
      completion(.failure(APIError.invalidURL))
      return
    }

    let task = URLSession.shared.dataTask(with: url) { data, _, error in
      guard let data = data, error == nil else {
        if let error = error {
          completion(.failure(error))
        } else {
          completion(.failure(APIError.noDataReturned))
        }
        return
      }

      do {
        let result = try JSONDecoder().decode(expecting, from: data)
        completion(.success(result))
      } catch {
        completion(.failure(error))
      }
    }
    task.resume()
  }
}
