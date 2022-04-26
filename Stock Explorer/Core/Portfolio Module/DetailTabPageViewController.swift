//
//  DetailTabPageViewController.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 22.04.2022.
//

import UIKit

class DetailTabPageViewController: TabPageViewController {
  override init() {
    super.init()
    title = "Salesforce"
    let vc1 = DetailViewController()
    let vc2 = UIViewController()
    vc2.view.backgroundColor = .green
    let vc3 = UIViewController()
    vc3.view.backgroundColor = .blue
    let vc4 = UIViewController()
    vc4.view.backgroundColor = .cyan
    let vc5 = UIViewController()
    vc5.view.backgroundColor = .black
    let vc6 = UIViewController()
    vc6.view.backgroundColor = .secondarySystemBackground
    tabItems = [
      (vc1, "Details"),
      (vc2, "Description"),
      (vc3, "Forecasts"),
      (vc4, "Metrics"),
      (vc5, "News"),
      (vc6, "Events")
    ]
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
