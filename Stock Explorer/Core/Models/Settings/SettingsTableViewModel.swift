//
//  SettingsTableViewModel.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 17.04.2022.
//

import UIKit

struct SettingsTableViewModel {
  var dataSource: [Section] = [
    Section(title: "Account", cells: [
      .profileCell(model: ProfileCell(
        title: "Eugene Dudkin",
        icon: UIImage(systemName: "person.circle"),
        iconBackgroundColor: .systemPink,
        handler: nil
      )),
      .defaultCell(model: DefaultCell(
        title: "Notifications",
        handler: nil
        ))
    ]),

    Section(title: "Translation", cells: [
      .staticCell(model: StaticCell(
        title: "Default languages",
        icon: UIImage(systemName: "character"),
        iconBackgroundColor: .systemBlue,
        handler: nil
      )),
      .staticCell(model: StaticCell(
        title: "Storage",
        icon: UIImage(systemName: "opticaldiscdrive"),
        iconBackgroundColor: .systemPink,
        handler: nil
      ))
    ]),

    Section(title: "Voice", cells: [
      .staticCell(model: StaticCell(
        title: "Speech input",
        icon: UIImage(systemName: "speaker"),
        iconBackgroundColor: .systemBlue,
        handler: nil
      )),
      .staticCell(model: StaticCell(
        title: "Speech region",
        icon: UIImage(systemName: "location"),
        iconBackgroundColor: .systemPink,
        handler: nil
      )),
      .staticCell(model: StaticCell(
        title: "Pronunciation speed",
        icon: UIImage(systemName: "hare"),
        iconBackgroundColor: .red,
        handler: nil
      ))
    ]),

    Section(title: "Support", cells: [
      .staticCell(model: StaticCell(
        title: "Feedback",
        icon: UIImage(systemName: "rectangle.and.pencil.and.ellipsis"),
        iconBackgroundColor: .systemBlue,
        handler: nil
      )),
      .staticCell(model: StaticCell(
        title: "Help",
        icon: UIImage(systemName: "questionmark.circle"),
        iconBackgroundColor: .systemPink,
        handler: nil
      )),
      .switchCell(model: SwitchCell(
        title: "Send crash reports",
        icon: UIImage(systemName: "paperplane"),
        iconBackgroundColor: .systemPink,
        handler: nil,
        isOn: true
      )),
      .staticCell(model: StaticCell(
        title: "About",
        icon: UIImage(systemName: "info"),
        iconBackgroundColor: .red,
        handler: nil
      ))
    ]),

    Section(title: nil, cells: [
      .defaultCell(model: DefaultCell(
        title: "Clear Translation History",
        handler: {
          //
        }
      ))
    ])
  ]
}
