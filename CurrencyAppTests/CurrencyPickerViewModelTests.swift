//
//  CurrencyPickerViewModelTests.swift
//  CurrencyAppTests
//
//  Created by Nitin Chauhan on 26/02/22.
//

import XCTest
import RxSwift
@testable import CurrencyApp

class CurrencyPickerViewModelTests: XCTestCase {
    var viewModel : CurrencyPickerViewModel!
    fileprivate var uiconfig : MockUIConfig!
    fileprivate var tableDataSource : MockTableDataSource!
    fileprivate var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        self.uiconfig = MockUIConfig()
        self.tableDataSource = MockTableDataSource()
        self.viewModel = CurrencyPickerViewModel(uiConfig: uiconfig, dataSource: tableDataSource)
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.uiconfig = nil
        self.tableDataSource = nil
        super.tearDown()
    }

    func testInitialization() {
        // Initialize currency View Model
        XCTAssertNotNil(viewModel, "The currency view model should not be nil.")
        XCTAssertTrue(viewModel?.dataSource === tableDataSource, "The table datasource should be equal to the profile that was passed in.")
    }

}
