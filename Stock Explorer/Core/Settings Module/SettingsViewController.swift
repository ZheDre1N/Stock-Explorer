//
//  SettingsViewController.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 15.04.2022.
//

import UIKit

// swiftlint:disable all
final class SettingsViewController: UIViewController {
  // MARK: - NIB OUTLETS.
  private var tableView: UITableView = {
    let table = UITableView(frame: .zero, style: .grouped)
    table.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.description())
    table.register(DefaultTableViewCell.self, forCellReuseIdentifier: DefaultTableViewCell.description())
    table.register(StaticTableViewCell.self, forCellReuseIdentifier: StaticTableViewCell.description())
    table.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.description())
    table.backgroundColor = .secondarySystemBackground
    return table
  }()
  
  var tableDataSource = SettingsTableViewModel().dataSource

  // MARK: - View controller life cycle.
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(tableView)
    title = "Настройки"
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
}

extension SettingsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let section = tableDataSource[section]
    return section.title
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    tableDataSource.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tableDataSource[section].cells.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellModel = tableDataSource[indexPath.section].cells[indexPath.row]

    switch cellModel.self {
    case .profileCell(let model):
      let cell = tableView.dequeueReusableCell(
        withIdentifier: ProfileTableViewCell.description(),
        for: indexPath
      ) as! ProfileTableViewCell
      cell.configure(with: model)
      return cell

    case .defaultCell(let model):
      let cell = tableView.dequeueReusableCell(
        withIdentifier: DefaultTableViewCell.description(),
        for: indexPath
      ) as! DefaultTableViewCell
      cell.configure(with: model)
      return cell

    case .staticCell(let model):
      let cell = tableView.dequeueReusableCell(
        withIdentifier: StaticTableViewCell.description(),
        for: indexPath
      ) as! StaticTableViewCell
      cell.configure(with: model)
      return cell

    case .switchCell(let model):
      let cell = tableView.dequeueReusableCell(
        withIdentifier: SwitchTableViewCell.description(),
        for: indexPath
      ) as! SwitchTableViewCell
      cell.configure(with: model)
      return cell
    }
  }
}

extension SettingsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    let type = tableDataSource[indexPath.section].cells[indexPath.row]

    switch type.self {
    case .profileCell(let model):
      if let handler = model.handler {
        handler()
      }
    case .defaultCell(let model):
      if let handler = model.handler {
        handler()
      }
    case .staticCell(let model):
      if let handler = model.handler {
        handler()
      }
    case .switchCell(let model):
      if let handler = model.handler {
        handler()
      }
    }
  }
}
// swiftlint:enable all
