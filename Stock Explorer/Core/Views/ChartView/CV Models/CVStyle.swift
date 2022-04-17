//
//  CVStyle.swift
//
//
//  Created by Eugene Dudkin on 17.04.2022.
//

import UIKit

public struct CVStyle {
  // chart borders
  var borderColor: UIColor = .label

  // change style button
  var changeStyleButtonColor: UIColor = .systemCyan

  // fullScreen button
  var fullButtonTintColor: UIColor = .label

  // line chart color
  var chartLineColor: UIColor = .systemCyan
  var gradients: [CGColor] = [UIColor.systemCyan.cgColor, UIColor.clear.cgColor]

  // text
  var labelColor: CGColor = UIColor.label.cgColor

  // pointer
  var currentPricePointerColor: UIColor = .systemCyan

  // long press point
  var internPointColor: UIColor = .secondarySystemBackground
  var externalPointColor: UIColor = .systemCyan
}
