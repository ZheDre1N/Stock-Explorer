//
//  CVCandle.swift
//
//
//  Created by Eugene Dudkin on 17.04.2022.
//

public struct CVCandle {
  let date: String
  let label: String
  let close: Double
  let high: Double?
  let low: Double?
  let open: Double?

  public init(
    date: String,
    label: String,
    close: Double,
    high: Double?,
    low: Double?,
    open: Double?
  ) {
    self.date = date
    self.label = label
    self.close = close
    self.high = high
    self.low = low
    self.open = open
  }
}

extension CVCandle: Comparable {
  public static func < (
    lhs: CVCandle,
    rhs: CVCandle
  ) -> Bool {
    lhs.close < rhs.close
  }

  public static func == (
    lhs: CVCandle,
    rhs: CVCandle
  ) -> Bool {
    lhs.close == rhs.close
  }
}
