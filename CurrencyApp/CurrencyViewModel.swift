//
//  CurrencyViewModel.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 24/02/22.
//

import Foundation
import RxCocoa


final class CurrencyViewModel  : BaseViewModel{
    var networkManager: NetworkManagerProtocol!
    var parseManager: ParseManagerProtocol!
    var uiConfig: UIConfigurationProtocol
    var shouldDisplayActivityIndicator = BehaviorRelay<Bool>(value: false)
    var showErrorMessageContent = BehaviorRelay<String?>(value: nil)
    var reloadData = BehaviorRelay<Bool>(value: false)
    var dataSource: CurrencyDataSourceProtocol
    var rateModelArray = [RateModel]()
    
    
    // MARK: View Model initialisation with parameters
    init?(networkManager: NetworkManagerProtocol, uiConfig: UIConfigurationProtocol, dataSource : CurrencyDataSourceProtocol, parseManager: ParseManagerProtocol) {
        self.networkManager = networkManager
        self.uiConfig = uiConfig
        self.dataSource = dataSource
        self.parseManager = parseManager
    }
    
    func getlabelValues() -> [String]{
        var labelValueArray  = [String]()
        labelValueArray.append(titleLabelValue)
        labelValueArray.append(todayDate)
        labelValueArray.append(baseCurrency)
        return labelValueArray
    }
    
    // MARK: Title Value
    private var titleLabelValue : String{
        return uiConfig.homeTitle ?? ""
    }
    // MARK: Today Date
    private var todayDate : String{
        let today = Date()
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        return "\(&&"GetRate") \(dataSource.date ?? formatter1.string(from: today))"
    }
    // MARK: Base Currency
    private var baseCurrency : String{
        return "\(&&"Base_Currency") \(dataSource.base ?? "EUR")"
    }
    // MARK: Get Currencies from Server
    func getCurrencies(){
        self.getCurrenciesData()
    }
    
    // MARK: Get Converted Value from source to target currency
    func getConvertedAmountToStr(from : String, to: String, numberToConvert: Double) -> Double? {
        if let inputToEURRate = getCurrencyDefaultValue(fromCurrency: from), let targetToEURRate = getCurrencyDefaultValue(fromCurrency: to){
            let total = numberToConvert / inputToEURRate * targetToEURRate
            return total.rounded(toPlaces: 4)
        }
        return nil
    }
    
    private func getCurrencyDefaultValue(fromCurrency : String) -> Double? {
        if let rates = self.dataSource.rates {
            for rate in rates {
                if rate.currency == fromCurrency {
                    return rate.value
                }
            }
        }
        return nil
    }
    func swapCurrency(){
        if rateModelArray.count == 2{
            let rate = rateModelArray[0]
            rateModelArray[0] = rateModelArray[1]
            rateModelArray[1] = rate
        }
    }
    
}
extension CurrencyViewModel{
    // MARK: Requesting Currencies Data
    private func getCurrenciesData(){
        shouldDisplayActivityIndicator.accept(true)
        guard let networkManager = networkManager else {
            self.showErrorMessageContent.accept("Missing Network Manager")
            return
        }
        networkManager.getCurrenciesData(uri: .getCurrenciessUri) {[weak self] (responseData, error) in
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
            if let dataSourceVal = dataSource{
                ssSelf.dataSource = dataSourceVal
                ssSelf.reloadData.accept(true)
            }
        }
    }
}
