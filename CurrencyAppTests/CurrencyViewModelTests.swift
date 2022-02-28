//
//  CurrencyViewModelTests.swift
//  CurrencyAppTests
//
//  Created by Nitin Chauhan on 26/02/22.
//

import XCTest
import RxSwift
@testable import CurrencyApp

class CurrencyViewModelTests: XCTestCase {
    var viewModel : CurrencyViewModel!
    fileprivate var service : MockCurrencyService!
    fileprivate var uiconfig : MockUIConfig!
    fileprivate var tableDataSource: MockTableDataSource!
    fileprivate var parseManger: MockParseManager!
    fileprivate var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        self.service = MockCurrencyService()
        self.uiconfig = MockUIConfig()
        self.tableDataSource = MockTableDataSource()
        self.parseManger = MockParseManager()
        self.viewModel = CurrencyViewModel(networkManager: self.service, uiConfig: uiconfig, dataSource: tableDataSource, parseManager: parseManger)
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.service = nil
        self.uiconfig = nil
        self.tableDataSource = nil
        self.parseManger = nil
        super.tearDown()
    }
    func testInitialization() {
        // Initialize currency View Model
        XCTAssertNotNil(viewModel, "The currency view model should not be nil.")
        XCTAssertTrue(viewModel?.dataSource === tableDataSource, "The table datasource should be equal to the profile that was passed in.")
    }
    func testFetchWithOutNetworkManager() {
        viewModel.networkManager = nil
        let expectation = XCTestExpectation(description: "ViewModel should not be able to fetch without network manager")
        
        // expected to not be able to fetch currencies
        viewModel.showErrorMessageContent.asObservable().subscribe(onNext: { _ in
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.getCurrencies()
        wait(for: [expectation], timeout: 5.0)
    }
    func testFetchWithOutParseManager() {
        viewModel.parseManager = nil
        let expectation = XCTestExpectation(description: "ViewModel should not be able to fetch without parse manager")
        
        // expected to not be able to fetch currencies
        viewModel.showErrorMessageContent.asObservable().subscribe(onNext: { _ in
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.getCurrencies()
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchWithNoService() {
        
        let expectation = XCTestExpectation(description: "No service currency")
        
        // expected to not be able to fetch currencies
        viewModel.showErrorMessageContent.asObservable().subscribe(onNext: { message in
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.getCurrencies()
        wait(for: [expectation], timeout: 5.0)
    }
    func testFetchCurrencies() {
        
        let expectation = XCTestExpectation(description: "Currency List Fetch")
        
        // giving a service mocking currencies
        let dict = ["AED": 4.105205,
                    "AFN": 102.403427,
                    "ALL": 121.063819,]
        let data = Data(dict.description.utf8)
        service.data = data
        self.service.getCurrenciesData { (response , error) in
            if let err = error  {
                XCTAssert(false, err)
            }else{
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    func testConvertedAmountwithoutValues() {
        let expectation = XCTestExpectation(description: "Conversion Fails")
        
        if let _ = viewModel.getConvertedAmountToStr(from: "", to: "", numberToConvert: 0){
            XCTAssert(false)
        }else{
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
class MockCurrencyService : NetworkManagerProtocol {
    var data : Data?
    var errorMessage : String?
    func getCurrenciesData(completion: @escaping (Data?, String?) -> Void) {
        guard data != nil else {
            completion(nil, errorMessage)
            return
        }
        
        completion(data, nil)
    }
}

class MockUIConfig : UIConfigurationProtocol{
    var homeTitle: String?
    var selectionTitle: String?
    var themeColor: UIColor?
    var defaultInitialValue: Int64?
    var textColor: UIColor?
}
class MockTableDataSource : CurrencyDataSourceProtocol{
    var base: String?
    var date: String?
    var rates: [RateModel]?
    func getSectionCount() -> Int {
        return 0
    }
    func getRowCount() -> Int? {
        return 0
    }    
}

class MockParseManager : ParseManagerProtocol{
    func parseResponseToDataSource(responseData: Data, completion: @escaping (CurrencyDataSourceProtocol?, String?) -> Void) {

    }
}
