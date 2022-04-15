//
//  ScreensFactory.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 15.04.2022.
//

import UIKit

protocol ScreensFactorable {
  static func createTabBarController() -> UITabBarController
  static func createPortfolioModule() -> UIViewController
  static func createSearchModule() -> UIViewController
  static func createSettingsModule() -> UIViewController
}

final class ScreensFactory: ScreensFactorable {
  // MARK: - Tabs.
  static func createTabBarController() -> UITabBarController {
    let tabBarController = TabBarController(
      portfolio: PortfolioCoordinator(),
      search: SearchCoordinator(),
      settings: SettingsCoordinator()
    )
    return tabBarController
  }

  // MARK: - Portfolio tabs.
  static func createPortfolioModule() -> UIViewController {
    let view = PortfolioViewController()
    return view
  }

  // MARK: - Search tabs.
  static func createSearchModule() -> UIViewController {
    let view = SearchViewController()
    return view
  }

  // MARK: - Settings tabs.
  static func createSettingsModule() -> UIViewController {
    let view = SettingsViewController()
    return view
  }
}
