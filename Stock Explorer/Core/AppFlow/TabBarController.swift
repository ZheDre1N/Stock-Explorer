//
//  TabBarController.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 15.04.2022.
//

import UIKit

final class TabBarController: UITabBarController {
  var portfolio: ChildCoordinatable
  var search: ChildCoordinatable
  var settings: ChildCoordinatable

  init(
    portfolio: ChildCoordinatable,
    search: ChildCoordinatable,
    settings: ChildCoordinatable
  ) {
    self.portfolio = portfolio
    self.search = search
    self.settings = settings
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewControllers()
    configureTabBars()
    customizeTabBarsAppearance()
  }

  private func configureViewControllers() {
    viewControllers = [
      portfolio.navigationController,
      search.navigationController,
      settings.navigationController
    ]
  }

  private func configureTabBars() {
    portfolio.navigationController.tabBarItem = UITabBarItem(
      title: "Portfolio",
      image: UIImage(systemName: "list.star"),
      selectedImage: UIImage(systemName: "list.star")
    )

    search.navigationController.tabBarItem = UITabBarItem(
      title: "Search",
      image: UIImage(systemName: "sparkle.magnifyingglass"),
      selectedImage: UIImage(systemName: "sparkle.magnifyingglass")
    )

    settings.navigationController.tabBarItem = UITabBarItem(
      title: "Settings",
      image: UIImage(systemName: "gearshape.2"),
      selectedImage: UIImage(systemName: "gearshape.2.fill")
    )
  }

  private func customizeTabBarsAppearance() {
    tabBar.tintColor = .SECyan
    tabBar.unselectedItemTintColor = .secondaryLabel
  }
}
