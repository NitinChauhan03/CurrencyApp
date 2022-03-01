//
//  HistoryViewModel.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 01/03/22.
//

import Foundation
import RxCocoa

final class HistoryViewModel : BaseViewModel {
    
    enum HistoryCounterSection {
        case headerSection
        case currencies
        case addMoreCurrencies
    }
    
    var uiConfig: UIConfigurationProtocol
    var shouldDisplayActivityIndicator = BehaviorRelay<Bool>(value: false)
    var showErrorMessageContent = BehaviorRelay<String?>(value: nil)
    var dataSource: CurrencyDataSourceProtocol
    var historicalDataSource =  CurrencyDataSource()
    var networkManager: NetworkManagerProtocol!
    var parseManager: ParseManagerProtocol!
    var sections: [HistoryCounterSection] = [.headerSection , .currencies, .addMoreCurrencies]
    var filteredRates: [RateModel]?
    var reloadData = BehaviorRelay<Bool>(value: false)
    
    
    // MARK: View Model initialisation with parameters
    init?(networkManager: NetworkManagerProtocol, uiConfig: UIConfigurationProtocol, dataSource : CurrencyDataSourceProtocol, parseManager: ParseManagerProtocol) {
        self.networkManager = networkManager
        self.uiConfig = uiConfig
        self.dataSource = dataSource
        self.parseManager = parseManager
        CurrencyConvertorCache.shared.setPrimaryCurrencies()
    }
    
    // MARK: Number of section datasource
    func getSectionCountDataSource() -> [HistoryCounterSection]{
        return sections
    }
    
    // MARK: Number of rows datasource
    func getRowsCountForSection(section : Int) -> Int{
        switch getSectionCountDataSource()[section] {
        case .headerSection:
            return 1
        case .currencies:
            return CurrencyConvertorCache.shared.getPrimaryCurrencies().count
        case .addMoreCurrencies:
            return 1
        }
    }
    // MARK: Cell Data
    func getCurrenciesValueforRowIndex(index : Int) -> RateModel?{
        return self.historicalDataSource.rates?[index]
    }
    
    // MARK: Title Value
    var titleLabelValue : String{
        return uiConfig.historicalTitle ?? ""
    }
    
    func getHistoricalList(){
        self.getHistoricalData()
    }
    
    func getDefaultCurrencyFromUserDefaults() -> String {
        return historicalDataSource.base ?? "EUR"
    }
    
    func getDateArray() -> [String]{
        return Date.getDates(forLastNDays: 30)
    }
    
}

extension HistoryViewModel{
    // MARK: Requesting Historical Data
    private func getHistoricalData(){
        shouldDisplayActivityIndicator.accept(true)
        guard let networkManager = networkManager else {
            self.showErrorMessageContent.accept("Missing Network Manager")
            return
        }
        networkManager.getCurrenciesData(uri: .getHistoricalUri) {[weak self] (responseData, error) in
            self?.shouldDisplayActivityIndicator.accept(false)
            guard let sSelf = self else { return }
            DispatchQueue.main.async {
                guard error == nil else {
                    sSelf.showErrorMessageContent.accept(error)
                    return
                }
                if let responseData = responseData{
                    sSelf.parseResponsetoDataSource(responseData: responseData)
                }
            }
        }
    }
    
    private func parseResponsetoDataSource(responseData: Data){
        guard let parseManager = self.parseManager else {
            self.showErrorMessageContent.accept("Missing Parse Manager")
            return
        }
        parseManager.parseResponseToDataSource(responseData: responseData) {[weak self] (dataSource, error)  in
            guard let ssSelf = self else { return }
            guard error == nil else {
                ssSelf.showErrorMessageContent.accept(error)
                return
            }
            if let dataSourceVal = dataSource as? CurrencyDataSource{
                ssSelf.historicalDataSource = dataSourceVal
                ssSelf.reloadData.accept(true)
            }
        }
    }
}
