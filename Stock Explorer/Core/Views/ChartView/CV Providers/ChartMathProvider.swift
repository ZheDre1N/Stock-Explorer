//
//  CVMathLogic.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 19.04.2022.
//

import Foundation
import UIKit

protocol ChartMathProvider {
  func getDrawableDataSourceRange(
    offsetX: Double,
    viewWidth: Double,
    dataSourceCount: Int,
    xPointSpace: Double,
    visibility: Int
  ) -> ClosedRange<Int>?
}

class DefaultChartMath: ChartMathProvider {
  func getDrawableDataSourceRange(
    offsetX: Double,
    viewWidth: Double,
    dataSourceCount: Int,
    xPointSpace: Double,
    visibility: Int
  ) -> ClosedRange<Int>? {
    guard xPointSpace > 0 else { return nil }
    var leftIndex = Int(offsetX) / Int(xPointSpace) - visibility
    var rightIndex = (Int(offsetX) + Int(viewWidth + xPointSpace)) / Int(xPointSpace) + visibility

    if leftIndex < 0 {
      leftIndex = 0
    }

    if rightIndex > dataSourceCount {
      rightIndex = dataSourceCount
    }

    return leftIndex...rightIndex
  }
}
