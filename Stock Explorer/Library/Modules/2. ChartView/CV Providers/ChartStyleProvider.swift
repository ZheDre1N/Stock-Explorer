//
//  CVStyle.swift
//
//
//  Created by Eugene Dudkin on 17.04.2022.
//

import UIKit

protocol ChartStyleProvider {
  var borderColor: UIColor { get set }
  var changeStyleButtonColor: UIColor { get set }
  var fullButtonTintColor: UIColor { get set }
  var chartLineColor: UIColor { get set }
  var gradients: [CGColor] { get set }
  var labelColor: CGColor { get set }
  var currentPricePointerColor: UIColor { get set }
  var internPointColor: UIColor { get set }
  var externalPointColor: UIColor { get set }
}

public class DefaultChartStyle: ChartStyleProvider {
  var borderColor: UIColor = .lightGray
  var changeStyleButtonColor: UIColor = .SECyan
  var fullButtonTintColor: UIColor = .label
  var chartLineColor: UIColor = .SECyan
  var gradients: [CGColor] = [UIColor.SECyan.cgColor, UIColor.clear.cgColor]
  var labelColor: CGColor = UIColor.label.cgColor
  var currentPricePointerColor: UIColor = .SECyan
  var internPointColor: UIColor = .secondarySystemBackground
  var externalPointColor: UIColor = .SECyan
}
