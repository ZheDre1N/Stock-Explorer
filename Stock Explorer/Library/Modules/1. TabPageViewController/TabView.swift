//
//  TabView.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 22.04.2022.
//

import UIKit

class TabView: UIView {

  // MARK: Interface
  public var pageHandler: ((
    _ index: Int,
    _ direction: UIPageViewController.NavigationDirection
  ) -> Void)?

  public var pageTabItems: [String] = [] {
    didSet {
      pageTabItemsCount = pageTabItems.count
      beforeIndex = pageTabItems.count
    }
  }
  public var layouted: Bool = false

  // MARK: Framing
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.register(
      TabCollectionCell.self,
      forCellWithReuseIdentifier: TabCollectionCell.description()
    )
    return collectionView
  }()

  private let bottomBorder: UIView = {
    let view = UIView()
    return view
  }()

  private let currentBarView: UIView = {
    let view = UIView()
    return view
  }()

  // MARK: Properties
  private var option: TabPageOption = TabPageOption()
  private var cellForSize: TabCollectionCell!

  private var beforeIndex: Int = 0
  private var currentIndex: Int = 0
  private var pageTabItemsCount: Int = 0
  private var collectionViewContentOffsetX: CGFloat = 0.0

//  private var currentBarViewWidth: CGFloat = 0.0
//  private var shouldScrollToItem: Bool = false
//  private var pageTabItemsWidth: CGFloat = 0.0
//  private var currentBarViewLeftConstraint: NSLayoutConstraint?
//  @IBOutlet var contentView: UIView!
//  @IBOutlet fileprivate weak var collectionView: UICollectionView!
//  @IBOutlet fileprivate weak var currentBarView: UIView!
//  @IBOutlet fileprivate weak var currentBarViewWidthConstraint: NSLayoutConstraint!
//  @IBOutlet fileprivate weak var currentBarViewHeightConstraint: NSLayoutConstraint!
//  @IBOutlet fileprivate weak var bottomBarViewHeightConstraint: NSLayoutConstraint!

  init(option: TabPageOption) {
    super.init(frame: CGRect.zero)
    self.option = option
    configureUI()
    configureDataSource()
    configureDelegates()
    cellForSize = TabCollectionCell(frame: .zero)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  private func configureUI() {
    addSubview(collectionView)
    addSubview(bottomBorder)
    collectionView.addSubview(currentBarView)

    // 1. CollectionView
    collectionView.backgroundColor = option.navigationBarBackgroundColor.withAlphaComponent(option.tabBarAlpha)

    // 2. BottomBorder
    bottomBorder.backgroundColor = option.navBarBottomBorderColor

    // 3. CurrentBarView
    currentBarView.backgroundColor = option.currentColor
  }

  private func configureDataSource() {
    collectionView.dataSource = self
  }

  private func configureDelegates() {
    collectionView.delegate = self
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    collectionView.frame = self.bounds
    bottomBorder.frame = CGRect(
      x: 0,
      y: self.frame.size.height - option.navBarBottomBorderHeight,
      width: self.frame.size.width,
      height: option.navBarBottomBorderHeight
    )
  }
}

// MARK: - View

extension TabView {
  func scrollCurrentBarView(_ index: Int, contentOffsetX: CGFloat) {
    let currentIndexPath = IndexPath(item: currentIndex, section: 0)
    let nextIndexPath = IndexPath(item: index, section: 0)

    guard
      let currentCell = collectionView.cellForItem(at: currentIndexPath) as? TabCollectionCell,
      let nextCell = collectionView.cellForItem(at: nextIndexPath) as? TabCollectionCell
    else {
      return
    }

    currentCell.hideCurrentBarView()
    nextCell.hideCurrentBarView()
    currentBarView.isHidden = false

    let scrollRate = contentOffsetX / frame.width

    if abs(scrollRate) > 0.5 {
      nextCell.highlightTitle()
      currentCell.unHighlightTitle()
    } else {
      nextCell.unHighlightTitle()
      currentCell.highlightTitle()
    }

    let currentBarViewOffsetX: CGFloat = {
      let startedValue = currentCell.frame.minX
      let endValue = nextCell.frame.minX
      let offset = startedValue + (endValue - startedValue) * abs(scrollRate)
      return offset
    }()

    let currentBarViewWidth: CGFloat = {
      let startedValue = currentCell.frame.size.width
      let endValue = nextCell.frame.size.width
      let width = startedValue + (endValue - startedValue) * abs(scrollRate)
      return width
    }()

    currentBarView.frame = CGRect(
      x: currentBarViewOffsetX,
      y: option.tabHeight - option.currentBarHeight,
      width: currentBarViewWidth,
      height: option.currentBarHeight
    )

    if abs(scrollRate) == 1 {
      currentBarView.isHidden = true
    }
  }

  func scrollToHorizontalCenter() {
    let indexPath = IndexPath(item: currentIndex, section: 0)
    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    collectionViewContentOffsetX = collectionView.contentOffset.x
  }

  func updateCurrentIndex(_ index: Int, shouldScroll: Bool) {
    deselectVisibleCells()
    currentIndex = index
    let indexPath = IndexPath(item: currentIndex, section: 0)
    moveCurrentBarView(indexPath, animated: true, shouldScroll: shouldScroll)
  }

  private func updateCurrentIndexForTap(_ index: Int) {
    deselectVisibleCells()
    currentIndex = index
    let indexPath = IndexPath(item: index, section: 0)
    moveCurrentBarView(indexPath, animated: true, shouldScroll: true)
  }

  /**
   Move the collectionView to IndexPath of Current
   
   - parameter indexPath: Next IndexPath
   - parameter animated: true when you tap to move the isInfinityTabCollectionCell
   - parameter shouldScroll:
   */
  private func moveCurrentBarView(_ indexPath: IndexPath, animated: Bool, shouldScroll: Bool) {
//    if shouldScroll {
//      collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
//      layoutIfNeeded()
//      collectionViewContentOffsetX = 0.0
//      currentBarViewWidth = 0.0
//    }
//    if let cell = collectionView.cellForItem(at: indexPath) as? TabCollectionCell {
//      currentBarView.isHidden = false
//      if animated && shouldScroll {
//        cell.isCurrent = true
//      }
//      cell.hideCurrentBarView()
//      currentBarViewWidthConstraint.constant = cell.frame.width
//      currentBarViewLeftConstraint?.constant = cell.frame.origin.x
//      UIView.animate(withDuration: 0.2, animations: {
//        self.layoutIfNeeded()
//      }, completion: { _ in
//        if !animated && shouldScroll {
//          cell.isCurrent = true
//        }
//
//        self.updateCollectionViewUserInteractionEnabled(true)
//      })
//    }
//    beforeIndex = currentIndex
  }

  func updateCollectionViewUserInteractionEnabled(_ userInteractionEnabled: Bool) {
    collectionView.isUserInteractionEnabled = userInteractionEnabled
  }

  private func deselectVisibleCells() {
    collectionView
      .visibleCells
      .compactMap { $0 as? TabCollectionCell }
      .forEach { $0.isCurrent = false }
  }
}

// MARK: - UICollectionViewDataSource

extension TabView: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return pageTabItemsCount
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: TabCollectionCell.description(),
      for: indexPath
    ) as? TabCollectionCell else {
      return UICollectionViewCell()
    }
    configureCell(cell, indexPath: indexPath)
    return cell
  }

  private func configureCell(_ cell: TabCollectionCell, indexPath: IndexPath) {
    let fixedIndex = indexPath.item
    cell.cellTitle = pageTabItems[fixedIndex]
    cell.option = option
    cell.isCurrent = fixedIndex == (currentIndex % pageTabItemsCount)
    cell.cellHandler = { [weak self, weak cell] in
      var direction: UIPageViewController.NavigationDirection = .forward
      if let currentIndex = self?.currentIndex {

        if indexPath.item < currentIndex {
          direction = .reverse
        }

      }
      self?.pageHandler?(fixedIndex, direction)

      if cell?.isCurrent == false {
        // Not accept touch events to scroll the animation is finished
        self?.updateCollectionViewUserInteractionEnabled(false)
      }
      self?.updateCurrentIndexForTap(indexPath.item)
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    // FIX: Tabs are not displayed when processing is performed during introduction display
    if let cell = cell as? TabCollectionCell, layouted {
      let fixedIndex = indexPath.item
      cell.isCurrent = fixedIndex == (currentIndex % pageTabItemsCount)
    }
  }
}

// MARK: - UIScrollViewDelegate

extension TabView: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.isDragging {
      currentBarView.isHidden = true
      let indexPath = IndexPath(item: currentIndex, section: 0)
      if let cell = collectionView.cellForItem(at: indexPath) as? TabCollectionCell {
        cell.showCurrentBarView()
      }
    }
  }

  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    // Accept the touch event because animation is complete
    updateCollectionViewUserInteractionEnabled(true)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TabView: UICollectionViewDelegateFlowLayout {
  internal func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    configureCell(cellForSize, indexPath: indexPath)
    let size = cellForSize.sizeThatFits(CGSize(width: collectionView.bounds.width, height: option.tabHeight))
    return size
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 0.0
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 0.0
  }
}
