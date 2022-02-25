//
//  CurrencyPickerViewModel.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 25/02/22.
//

import Foundation
import RxCocoa

final class CurrencyPickerViewModel : BaseViewModel {
    
    private var networkManager: NetworkManager!
    var uiConfig: UIConfigurationProtocol
    var shouldDisplayActivityIndicator = BehaviorRelay<Bool>(value: false)
    var showErrorMessageContent = BehaviorRelay<String?>(value: nil)
    var reloadLst = BehaviorRelay<Bool>(value: false)
    private var dataSource: TableViewDataSourceProtocol
    
    
    // MARK: View Model initialisation with parameters
    init?(networkManager: NetworkManager, uiConfig: UIConfigurationProtocol, dataSource : TableViewDataSourceProtocol) {
        self.networkManager = networkManager
        self.uiConfig = uiConfig
        self.dataSource = dataSource
    }
    
    // MARK: Number of section datasource
    func getSectionCountDataSource() -> Int{
        return self.dataSource.getSectionCount()
    }
    
    // MARK: Number of rows datasource
    func getRowsCountForSection(index : Int) -> Int{
        if let row = self.dataSource.getRowCount(){
            return row
        }
        return 0
    }
    // MARK: Cell Data
    func getCurrenciesValueforRowIndex(index : Int) -> RateModel?{
        if let currencyArray = dataSource.rates{
            return currencyArray[index]
        }
        return nil
    }
    
    // MARK: Title Value
    var titleLabelValue : String{
        return uiConfig.selectionTitle
    }
    // MARK: Today Date
    var todayDate : String{
        let today = Date()
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        return "Rates as per Api Response Date \(dataSource.date ?? formatter1.string(from: today))"
    }
    
}

