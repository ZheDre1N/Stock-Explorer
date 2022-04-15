//
//  AppCoordinator.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 15.04.2022.
//

import UIKit

class AppCoordinator: AppCoordinatable {
  private let window: UIWindow?
  var starterCoordinator: AppCoordinatable?

  init(
    window: UIWindow? = UIWindow()
  ) {
    self.window = window
    setupStarterCoordinator()
  }

  func setupStarterCoordinator() {
    // The best place to check loggin user or not
    starterCoordinator = AuthorizedCoordinator(window: window)
  }

  func start() {
    starterCoordinator?.start()
  }
}
