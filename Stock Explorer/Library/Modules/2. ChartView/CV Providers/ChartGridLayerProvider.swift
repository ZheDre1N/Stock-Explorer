//
//  ChartGridLayerProvider.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 19.04.2022.
//

import UIKit

protocol ChartGridLayerProvider {
  func drawGridLayer(on layer: CALayer, dataSource: [CVCandle], xPointSpace: CGFloat) -> CALayer
}

class DefaultGridLayerProvider: ChartGridLayerProvider {
  func drawGridLayer(on layer: CALayer, dataSource: [CVCandle], xPointSpace: CGFloat) -> CALayer {
    let labelFont = CTFont(.label, size: 0, language: .none)
    let labelSize: CGFloat = 11

    for valueIndex in 0..<dataSource.count where valueIndex % 16 == 0 {
      let textLabelLayer = CATextLayer()
      let label = dataSource[valueIndex].date
      let textLabelLayerWidth: CGFloat = 250

      textLabelLayer.frame = CGRect(
        x: CGFloat(valueIndex) * xPointSpace - textLabelLayerWidth / 2,
        y: 26,
        width: textLabelLayerWidth,
        height: labelSize
      )

      let degrees = 270.0
      let radians = CGFloat(degrees * Double.pi / 180)
      textLabelLayer.transform = CATransform3DMakeRotation(
        radians,
        0.0,
        0.0,
        1.0
      )

      textLabelLayer.foregroundColor = UIColor.label.cgColor
      textLabelLayer.contentsScale = UIScreen.main.scale
      textLabelLayer.font = labelFont
      textLabelLayer.fontSize = labelSize
      textLabelLayer.string = label
      textLabelLayer.alignmentMode = .center
      layer.addSublayer(textLabelLayer)
    }
    return layer
  }
}
