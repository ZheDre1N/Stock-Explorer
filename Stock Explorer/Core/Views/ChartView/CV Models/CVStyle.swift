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
  var changeStyleButtonColor: UIColor = .SECyan

  // fullScreen button
  var fullButtonTintColor: UIColor = .label

  // line chart color
  var chartLineColor: UIColor = .SECyan
  var gradients: [CGColor] = [UIColor.SECyan.cgColor, UIColor.clear.cgColor]

  // text
  var labelColor: CGColor = UIColor.label.cgColor

  // pointer
  var currentPricePointerColor: UIColor = .SECyan

  // long press point
  var internPointColor: UIColor = .secondarySystemBackground
  var externalPointColor: UIColor = .SECyan
}
