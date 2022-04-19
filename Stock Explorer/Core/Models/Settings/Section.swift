//
//  Section.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 19.04.2022.
//

struct Section {
  let title: String?
  let cells: [CustomCellType]
}

enum CustomCellType {
  case profileCell(model: ProfileCell)
  case defaultCell(model: DefaultCell)
  case staticCell(model: StaticCell)
  case switchCell(model: SwitchCell)
}
