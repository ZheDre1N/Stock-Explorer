//
//  HomeViewController.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 15.04.2022.
//

import UIKit

class PortfolioViewController: UIViewController {
  private let table: UITableView = {
    let table = UITableView()
    table.backgroundColor = .clear
    return table
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureTableView()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    table.frame = view.bounds
  }

  private func configureViewController() {
    navigationItem.title = "Portfolio"
    view.backgroundColor = .secondarySystemBackground
  }
  private func configureTableView() {
    view.addSubview(table)
    table.delegate = self
    table.dataSource = self
  }
}

extension PortfolioViewController: UITableViewDelegate {}

extension PortfolioViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = "\(indexPath.row)"
    return cell
  }
}
