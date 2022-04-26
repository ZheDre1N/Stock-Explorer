//
//  MarketDataResponse.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 17.04.2022.
//

import Foundation

struct MarketDataResponse: Codable {
  let open: [Double]
  let close: [Double]
  let high: [Double]
  let low: [Double]
  let status: String
  let timestamps: [TimeInterval]

  enum CodingKeys: String, CodingKey {
    case open = "o"
    case low = "l"
    case close = "c"
    case high = "h"
    case status = "s"
    case timestamps = "t"
  }

  var candleSticks: [CVCandle] {
    var result = [CVCandle]()

    for index in 0..<open.count {
      let data = Date(timeIntervalSince1970: timestamps[index])
      let shortDate = DateFormatter.chartShortDateFormatter.string(from: data)
      let longDate = DateFormatter.chartLongDateFormatter.string(from: data)

      result.append(.init(
        date: longDate.description,
        label: shortDate.description,
        close: close[index],
        high: nil,
        low: nil,
        open: nil
      ))
    }
    return result
  }
}

struct CandleStick {
  let date: Date
  let high: Double
  let low: Double
  let open: Double
  let close: Double
}
