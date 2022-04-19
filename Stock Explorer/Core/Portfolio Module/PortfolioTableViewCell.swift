//
//  PortfolioTableViewCell.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 15.04.2022.
//

import UIKit

class PortfolioTableViewCell: UITableViewCell {
  // MARK: Public Interface
  public func configure() {
    iconImageView.image = UIImage(systemName: "globe")
    titleLabel.text = "Salesforce"
    detailLabel.text = "7 шт. 250$"
    priceLabel.text = "4500$"
    changeLabel.text = "+ 350$ (+ 15.0%)"
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    iconImageView.image = nil
    titleLabel.text = nil
    detailLabel.text = nil
    priceLabel.text = nil
    changeLabel.text = nil
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    createLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    createLayout()
  }

  // MARK: Private properties
  private var iconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.sizeToFit()
    titleLabel.numberOfLines = 0
    titleLabel.adjustsFontForContentSizeCategory = true
    return titleLabel
  }()

  private var detailLabel: UILabel = {
    let detailLabel = UILabel()
    detailLabel.sizeToFit()
    detailLabel.numberOfLines = 0
    detailLabel.textColor = .secondaryLabel
    detailLabel.adjustsFontForContentSizeCategory = true
    return detailLabel
  }()

  private var priceLabel: UILabel = {
    let priceLabel = UILabel()
    priceLabel.sizeToFit()
    priceLabel.numberOfLines = 0
    priceLabel.adjustsFontForContentSizeCategory = true
    return priceLabel
  }()

  private var changeLabel: UILabel = {
    let changeLabel = UILabel()
    changeLabel.sizeToFit()
    changeLabel.numberOfLines = 0
    changeLabel.textColor = .systemGreen
    changeLabel.adjustsFontForContentSizeCategory = true
    return changeLabel
  }()

  // MARK: ViewModel
  struct ViewModel {
    let icon: UIImage
    let title: String
    let shareCount: Int
    let currentPrice: Float
    let averagePrice: Float
    let currencyCode: String
  }

  // MARK: Layout
  private func createLayout() {
    let cellStack = configureCellStack(with: [iconImageView, configureLeftStack(), configureRightStack()])
    contentView.addSubview(cellStack)
  }

  private func configureCellStack(with subviews: [UIView]) -> UIStackView {
    let cellStack = UIStackView(arrangedSubviews: subviews)
    cellStack.alignment = .fill
    cellStack.axis = .horizontal
    cellStack.frame = contentView.bounds
    return cellStack
  }

  private func configureLeftStack() -> UIStackView {
    let leftStack = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
    leftStack.axis = .vertical
    leftStack.alignment = .leading
    return leftStack
  }

  private func configureRightStack() -> UIStackView {
    let rightStack = UIStackView(arrangedSubviews: [priceLabel, changeLabel])
    rightStack.axis = .vertical
    rightStack.alignment = .trailing
    return rightStack
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    createLayout()
  }
}
