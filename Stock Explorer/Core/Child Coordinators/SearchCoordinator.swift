//
//  SavedCoordinator.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 15.04.2022.
//

import UIKit

final class SearchCoordinator: ChildCoordinatable {
  var navigationController: UINavigationController

  required init() {
    let navVC = UINavigationController()
    navVC.navigationBar.prefersLargeTitles = true
    self.navigationController = navVC
    let view = ScreensFactory.createSearchModule()
    self.navigationController.pushViewController(view, animated: false)
  }
}

extension SearchCoordinator {}
