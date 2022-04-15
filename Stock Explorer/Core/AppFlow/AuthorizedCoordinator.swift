//
//  AuthorizedCoordinator.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 15.04.2022.
//

import UIKit

class AuthorizedCoordinator: AppCoordinatable {
  private let window: UIWindow?

  init(
    window: UIWindow?
  ) {
    self.window = window
  }

  func start() {
    self.window?.rootViewController = ScreensFactory.createTabBarController()
    self.window?.makeKeyAndVisible()
  }
}
