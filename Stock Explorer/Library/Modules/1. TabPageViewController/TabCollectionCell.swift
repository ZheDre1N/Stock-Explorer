//
//  TabCollectionCell.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 22.04.2022.
//

import UIKit

class TabCollectionCell: UICollectionViewCell {

  // MARK: Interface
  public var cellHandler: (() -> Void)?
  public var option: TabPageOption = TabPageOption()
  public var cellTitle: String = "" {
    didSet {
      selectButton.setTitle(cellTitle, for: .normal)
      selectButton.sizeToFit()
    }
  }
  public var isCurrent: Bool = false {
    didSet {
      selectedBarView.isHidden = !isCurrent
      if isCurrent {
        highlightTitle()
      } else {
        unHighlightTitle()
      }
      selectedBarView.backgroundColor = option.highlightedColor
    }
  }

  public func configure(with viewModel: ViewModel) {
  }

  // MARK: ViewModel
  struct ViewModel {
    let title: String
    let handler: (() -> Void)
    let isSelected: Bool
    let option: TabPageOption
  }

  // MARK: Framing
  private let selectButton: UIButton = {
    let button = UIButton()
    return button
  }()

  private let selectedBarView: UIView = {
    let view = UIView()
    return view
  }()

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  private func configureUI() {
    contentView.addSubview(selectButton)
    selectButton.addTarget(self, action: #selector(selectButtonWasTapped), for: .touchUpInside)
    contentView.addSubview(selectedBarView)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    selectButton.frame = contentView.bounds
    selectedBarView.frame = CGRect(
      x: 0,
      y: contentView.frame.size.height - option.currentBarHeight,
      width: contentView.frame.size.width,
      height: option.currentBarHeight
    )
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    return intrinsicContentSize
  }
}

// MARK: View
extension TabCollectionCell {
  override var intrinsicContentSize: CGSize {
    let width = selectButton.intrinsicContentSize.width + option.tabMargin * 2
    let size = CGSize(width: width, height: option.tabHeight)
    return size
  }

  func hideCurrentBarView() {
    selectedBarView.isHidden = true
  }

  func showCurrentBarView() {
    selectedBarView.isHidden = false
  }

  func highlightTitle() {
    selectButton.setTitleColor(option.highlightedColor, for: .normal)
    selectButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: option.fontSize)
  }

  func unHighlightTitle() {
    selectButton.setTitleColor(option.unHighlightedColorColor, for: .normal)
    selectButton.titleLabel?.font = UIFont.systemFont(ofSize: option.fontSize)
  }
}

// MARK: - Actions
extension TabCollectionCell {
  @objc func selectButtonWasTapped(_ sender: UIButton) {
    cellHandler?()
  }
}
