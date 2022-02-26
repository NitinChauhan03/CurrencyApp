//
//  CurrencyDataSourceTests.swift
//  CurrencyAppTests
//
//  Created by Nitin Chauhan on 26/02/22.
//

import XCTest
@testable import CurrencyApp

class CurrencyDataSourceTests: XCTestCase {

    var dataSource : CurrencyDataSource!

    override func setUp() {
        super.setUp()
        dataSource = CurrencyDataSource()
    }
    
    override func tearDown() {
        dataSource = nil
        super.tearDown()
    }
    
    func testValueInDataSource() {

            // giving data value
        let rate1 =  RateModel(currency: "AED", value: 4.105205)
        let rate2 =  RateModel(currency: "AFN", value: 102.403427)
        dataSource.rates = [rate1, rate2]

            // expected one section
        XCTAssertEqual(dataSource.getSectionCount() , 1, "Expected one section in table view")

            // expected two cells
        XCTAssertEqual(dataSource.getRowCount(), 2, "Expected no cell in table view")
    }

}
