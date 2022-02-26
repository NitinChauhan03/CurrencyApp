//
//  CurrencyViewModel.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 24/02/22.
//

import Foundation
import UIKit
import RxCocoa


final class CurrencyViewModel  : BaseViewModel{
    var networkManager: NetworkManagerProtocol!
    var parseManager: ParseManagerProtocol!
    var uiConfig: UIConfigurationProtocol
    var shouldDisplayActivityIndicator = BehaviorRelay<Bool>(value: false)
    var showErrorMessageContent = BehaviorRelay<String?>(value: nil)
    var dataSource: CurrencyDataSourceProtocol
    
    // MARK: View Model initialisation with parameters
    init?(networkManager: NetworkManagerProtocol, uiConfig: UIConfigurationProtocol, dataSource : CurrencyDataSourceProtocol, parseManager: ParseManagerProtocol) {
        self.networkManager = networkManager
        self.uiConfig = uiConfig
        self.dataSource = dataSource
        self.parseManager = parseManager
    }
    
    // MARK: Title Value
    var titleLabelValue : String{
        return uiConfig.homeTitle ?? ""
    }
    // MARK: Today Date
    var todayDate : String{
        let today = Date()
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        return "Rates as per Date \(dataSource.date ?? formatter1.string(from: today))"
    }
    func getCurrencies(){
        self.getCurrenciesData()
    }
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
    
}
extension CurrencyViewModel{
    // MARK: Requesting Currencies Data
    private func getCurrenciesData(){
        shouldDisplayActivityIndicator.accept(true)
        guard let networkManager = networkManager else {
            self.showErrorMessageContent.accept("Missing Network Manager")
            return
        }
        networkManager.getCurrenciesData {[weak self] (responseData, error) in
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
            if let _dataSource = dataSource{
                ssSelf.dataSource = _dataSource
            }
        }
    }
}
