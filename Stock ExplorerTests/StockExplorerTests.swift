//
//  StockExplorerTests.swift
//  Stock ExplorerTests
//
//  Created by Eugene Dudkin on 27.04.2022.
//

import XCTest
@testable import Stock_Explorer

class StockExplorerTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testExample() throws {
    let detailVC = DetailViewController()
    XCTAssertEqual(nil, detailVC.navigationItem.title)
  }
}
