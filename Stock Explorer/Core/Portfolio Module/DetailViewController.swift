//
//  DetailViewController.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 17.04.2022.
//

import UIKit

class DetailViewController: UIViewController {
  private let table: UITableView = {
    let table = UITableView(frame: .zero, style: .grouped)
    table.backgroundColor = .clear
    table.register(PortfolioTableViewCell.self, forCellReuseIdentifier: PortfolioTableViewCell.description())
    return table
  }()

  private let chartView: ChartView = {
    let chartView = ChartView()
    chartView.fullScreenButtonHandler = {
      let fullChartVC = FullChartViewController()
    }
    chartView.frame.size.height = 350
    return chartView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureTableView()

    APICaller.shared.marketData(for: "CRM") { result in
      switch result {
      case .success(let response):
        DispatchQueue.main.async {
          self.chartView.dataSource = response.candleSticks
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    table.frame = view.bounds
  }

  private func configureViewController() {
    navigationItem.title = "Salesforce"
    view.backgroundColor = .secondarySystemBackground
  }
  private func configureTableView() {
    view.addSubview(table)
    table.tableHeaderView = chartView
    table.delegate = self
    table.dataSource = self
  }
}

extension DetailViewController: UITableViewDelegate {

}

extension DetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    UITableViewCell()
  }
}
