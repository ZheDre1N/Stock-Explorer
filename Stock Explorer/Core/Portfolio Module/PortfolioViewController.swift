//
//  HomeViewController.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 15.04.2022.
//

import UIKit

class PortfolioViewController: UIViewController {
  private let table: UITableView = {
    let table = UITableView(frame: .zero, style: .grouped)
    table.backgroundColor = .clear
    table.register(PortfolioTableViewCell.self, forCellReuseIdentifier: PortfolioTableViewCell.description())
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

extension PortfolioViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let detailVC = DetailViewController()
    navigationController?.pushViewController(detailVC, animated: true)
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    "Stocks"
  }
}

extension PortfolioViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: PortfolioTableViewCell.description(),
      for: indexPath
    ) as? PortfolioTableViewCell else {
      fatalError()
    }
    cell.configure()
    return cell
  }
}
