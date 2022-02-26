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
    private var networkManager: NetworkManager!
    var uiConfig: UIConfigurationProtocol
    var shouldDisplayActivityIndicator = BehaviorRelay<Bool>(value: false)
    var showErrorMessageContent = BehaviorRelay<String?>(value: nil)
    var dataSource: TableViewDataSourceProtocol
    
    // MARK: View Model initialisation with parameters
    init?(networkManager: NetworkManager, uiConfig: UIConfigurationProtocol, dataSource : TableViewDataSourceProtocol) {
        self.networkManager = networkManager
        self.uiConfig = uiConfig
        self.dataSource = dataSource
    }
    
    // MARK: Title Value
    var titleLabelValue : String{
        return uiConfig.homeTitle
    }
    // MARK: Today Date
    var todayDate : String{
        let today = Date()
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        return "Rates as per Date \(dataSource.date ?? formatter1.string(from: today))"
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
    func getCurrenciesData(){
        shouldDisplayActivityIndicator.accept(true)
        var ratesArray: [RateModel] = []
        networkManager.getCurrenciesData {[weak self] (response, error) in
            self?.shouldDisplayActivityIndicator.accept(false)
            guard let sSelf = self else { return }
            DispatchQueue.main.async {
                guard error == nil else {
                    sSelf.showErrorMessageContent.accept(error)
                    return
                }
                if let res = response, res.rates.count > 0{
                    for (value, key) in res.rates {
                        let rate = RateModel(currency: value, value: key)
                        ratesArray.append(rate)
                    }
                    ratesArray.sort { (a, b) -> Bool in
                        a.currency < b.currency
                    }
                    sSelf.dataSource.base = res.base
                    sSelf.dataSource.date = res.date
                    sSelf.dataSource.rates = ratesArray
                }
            }
        }
    }
}
