//
//  TabPageOption.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 22.04.2022.
//

import UIKit

public struct TabPageOption {
  public init() {}
  public var fontSize = UIFont.systemFontSize
  public var highlightedColor = UIColor.SECyan
  public var unHighlightedColorColor: UIColor = .label
  public var tabHeight: CGFloat = 32.0
  public var tabMargin: CGFloat = 20.0
  public var currentBarHeight: CGFloat = 2.0
  public var navigationBarBackgroundColor: UIColor = .secondarySystemBackground
  public var pageBackgoundColor: UIColor = .secondarySystemBackground
  public var isTranslucent: Bool = true
  public var tabBarAlpha: CGFloat {
    return isTranslucent ? 0.95 : 1.0
  }

  public let navBarBottomBorderColor: UIColor = .secondaryLabel
  public let navBarBottomBorderHeight: CGFloat = 1
}
