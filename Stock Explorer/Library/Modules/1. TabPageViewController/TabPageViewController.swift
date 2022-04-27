//
//  TabPageViewController.swift
//  Stock Explorer
//
//  Created by Eugene Dudkin on 22.04.2022.
//

import UIKit

class TabPageViewController: UIPageViewController {

  // MARK: Interface
  public var option: TabPageOption = TabPageOption()
  public var tabItems: [(viewController: UIViewController, title: String)] = []

  // MARK: Properties
  private var previousIndex: Int = 0
  private var currentIndex: Int? {
    guard let viewController = viewControllers?.first else {
      return nil
    }
    return tabItems.map { $0.viewController }.firstIndex(of: viewController)
  }
  private var tabItemsCount: Int {
    return tabItems.count
  }

  private var defaultContentOffsetX: CGFloat {
    return self.view.bounds.width
  }

  private var shouldScrollCurrentBar: Bool = true
  private var tabView: TabView?

  // MARK: Init
  public init() {
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  }

  // MARK: Lifecycle
  override open func viewDidLoad() {
    super.viewDidLoad()
    configureTabView()
    configurePageViewController()
    configurePageScrollView()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tabView?.frame = CGRect(
      x: 0,
      y: self.view.safeAreaInsets.top,
      width: self.view.frame.size.width,
      height: option.tabHeight
    )
  }
}

// MARK: - Public Interface
extension TabPageViewController {

  func displayControllerWithIndex(
    _ index: Int,
    direction: UIPageViewController.NavigationDirection,
    animated: Bool
  ) {

    previousIndex = index
    shouldScrollCurrentBar = false
    let nextViewController: [UIViewController] = [tabItems[index].viewController]

    let completion: ((Bool) -> Void) = { [weak self] _ in
      self?.shouldScrollCurrentBar = true
      self?.previousIndex = index
    }

    setViewControllers(
      nextViewController,
      direction: direction,
      animated: animated,
      completion: completion)

    tabView?.updateCurrentIndex(index, shouldScroll: true)
  }
}

// MARK: - View

extension TabPageViewController {
  private func configureTabView() {
    tabView = TabView(option: option)
    guard let tabView = tabView else { return }
    view.addSubview(tabView)
    tabView.pageTabItems = tabItems.map({ $0.title})
    tabView.updateCurrentIndex(previousIndex, shouldScroll: true)
    tabView.pageHandler = { [weak self] (index: Int, direction: UIPageViewController.NavigationDirection) in
      self?.displayControllerWithIndex(index, direction: direction, animated: true)
    }
  }

  private func configurePageViewController() {
    dataSource = self
    delegate = self

    setViewControllers([tabItems[previousIndex].viewController],
                       direction: .forward,
                       animated: false,
                       completion: nil)
  }

  private func configurePageScrollView() {
    // Disable PageViewController's ScrollView bounce
    let scrollView = view.subviews.compactMap { $0 as? UIScrollView }.first
    scrollView?.delegate = self
    scrollView?.backgroundColor = option.pageBackgoundColor
    scrollView?.contentInsetAdjustmentBehavior = .automatic
  }
}

// MARK: - UIPageViewControllerDataSource

extension TabPageViewController: UIPageViewControllerDataSource {

  private func nextViewController(_ viewController: UIViewController, isAfter: Bool) -> UIViewController? {
    guard var index = tabItems.map({$0.viewController}).firstIndex(of: viewController) else {
      return nil
    }

    isAfter ? (index += 1) : (index -= 1)

    if index >= 0 && index < tabItems.count {
      return tabItems[index].viewController
    }
    return nil
  }

  public func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerAfter viewController: UIViewController
  ) -> UIViewController? {
    return nextViewController(viewController, isAfter: true)
  }

  public func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController? {
    return nextViewController(viewController, isAfter: false)
  }
}

// MARK: - UIPageViewControllerDelegate

extension TabPageViewController: UIPageViewControllerDelegate {
  public func pageViewController(
    _ pageViewController: UIPageViewController,
    willTransitionTo pendingViewControllers: [UIViewController]
  ) {
    shouldScrollCurrentBar = true
    tabView?.scrollToHorizontalCenter()

    // Order to prevent the the hit repeatedly during animation
    tabView?.updateCollectionViewUserInteractionEnabled(false)
  }

  public func pageViewController(
    _ pageViewController: UIPageViewController,
    didFinishAnimating finished: Bool,
    previousViewControllers: [UIViewController],
    transitionCompleted completed: Bool
  ) {
    if let currentIndex = currentIndex, currentIndex < tabItemsCount {
      tabView?.updateCurrentIndex(currentIndex, shouldScroll: false)
      previousIndex = currentIndex
    }

    tabView?.updateCollectionViewUserInteractionEnabled(true)
  }
}

// MARK: - UIScrollViewDelegate
extension TabPageViewController: UIScrollViewDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.x == defaultContentOffsetX || !shouldScrollCurrentBar {
      return
    }

    // (0..<tabItemsCount)
    var index: Int
    if scrollView.contentOffset.x > defaultContentOffsetX {
      index = previousIndex + 1
    } else {
      index = previousIndex - 1
    }

    if index == tabItemsCount {
      index = 0
    } else if index < 0 {
      index = tabItemsCount - 1
    }

    let scrollOffsetX = scrollView.contentOffset.x - view.frame.width
    tabView?.scrollCurrentBarView(index, contentOffsetX: scrollOffsetX)
  }

  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    tabView?.updateCurrentIndex(previousIndex, shouldScroll: true)
  }
}
