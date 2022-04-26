//
//  DateFormatter + Ext..swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 17.04.2022.
//

import Foundation

extension DateFormatter {
  static let chartShortDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
  }()

  static let chartLongDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
  }()
}
