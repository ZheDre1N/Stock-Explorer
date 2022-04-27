//
//  APICaller.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 17.04.2022.
//

import Foundation

final class APICaller {
  public static let shared = APICaller()
  private init() {}

  // MARK: Public
  public func marketData(
    for symbol: String,
    numberOfDays: TimeInterval = 3000,
    timeframe: APITimeframe = .oneDay,
    completion: @escaping(Result<MarketDataResponse, Error>) -> Void
  ) {
    let today = Date().addingTimeInterval(-(3600 * 24))
    let prior = today.addingTimeInterval(-(3600 * 24 * numberOfDays))

    let url = url(
      for: .marketData,
      queryParams: [
        "symbol": symbol,
        "resolution": timeframe.rawValue,
        "from": "\(Int(prior.timeIntervalSince1970))",
        "to": "\(Int(today.timeIntervalSince1970))"
      ]
    )
    request(url: url, expecting: MarketDataResponse.self, completion: completion)
  }

  public enum APITimeframe: String {
    case oneMin = "1"
    case fiveMin = "5"
    case fifteenMin = "15"
    case thirtyMin = "30"
    case oneHour = "60"
    case oneDay = "D"
    case oneWeek = "W"
    case oneMonth = "M"
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

  private func url(
    for endpoint: Endpoint,
    queryParams: [String: String] = [:]
  ) -> URL? {
    var urlString = Constants.baseURL + endpoint.rawValue
    var queryItems = [URLQueryItem]()

    for (name, value) in queryParams {
      queryItems.append(.init(name: name, value: value))
    }

    queryItems.append(.init(name: "token", value: Constants.apiKey))
    urlString += "?" + queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
    return URL(string: urlString)
  }

  private func request<T: Codable>(
    url: URL?,
    expecting: T.Type,
    completion: @escaping (Result<T, Error>
    ) -> Void) {
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
