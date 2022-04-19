//
//  CVMathLogic.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 19.04.2022.
//
import UIKit

protocol ChartMathProvider {
  func getDrawableDataSourceRange(
    offsetX: Double,
    viewWidth: Double,
    dataSourceCount: Int,
    xPointSpace: Double,
    visibility: Int
  ) -> Range<Int>?

  func getDrawableDataPoints(
    viewHeight: CGFloat,
    xPointSpace: CGFloat,
    with dataSource: [CVCandle],
    and range: Range<Int>
  ) -> [CGPoint]
}

class DefaultChartMath: ChartMathProvider {
  func getDrawableDataSourceRange(
    offsetX: Double,
    viewWidth: Double,
    dataSourceCount: Int,
    xPointSpace: Double,
    visibility: Int
  ) -> Range<Int>? {
    guard xPointSpace > 0, visibility > 0 else { return nil }
    var leftIndex = Int(offsetX) / Int(xPointSpace) - visibility
    var rightIndex = (Int(offsetX) + Int(viewWidth + xPointSpace)) / Int(xPointSpace) + visibility

    if leftIndex < 0 {
      leftIndex = 0
    }

    if rightIndex > dataSourceCount {
      rightIndex = dataSourceCount
    }

    return leftIndex..<rightIndex
  }

  func getDrawableDataPoints(
    viewHeight: CGFloat,
    xPointSpace: CGFloat,
    with dataSource: [CVCandle],
    and range: Range<Int>
  ) -> [CGPoint] {

    let visibleDataSource = Array(dataSource[range])

    if let max = visibleDataSource.max()?.close,
       let min = visibleDataSource.min()?.close {

      var result: [CGPoint] = []
      let minMaxRange = CGFloat(max - min)

      for index in range {
        let value = CGFloat(dataSource[index].close)
        let height = viewHeight / minMaxRange * (CGFloat(max) - value)
        let point = CGPoint(x: CGFloat(index) * xPointSpace, y: height)
        result.append(point)
      }
      return result
    }
    return []
  }
}
