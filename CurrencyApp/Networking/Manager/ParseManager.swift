//
//  ParseManager.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 26/02/22.
//

import Foundation

protocol ParseManagerProtocol{
    func parseResponseToDataSource(responseData: Data, completion : @escaping (_ dataSource: CurrencyDataSourceProtocol?,_ error: String?) -> Swift.Void)
}


class ParseManager : ParseManagerProtocol{
    func parseResponseToDataSource(responseData: Data, completion : @escaping (_ dataSource: CurrencyDataSourceProtocol?,_ error: String?) -> Swift.Void) {
        var ratesArray: [RateModel] = []
        do {
            let apiResponse = try JSONDecoder().decode(ExchangeRatesModel.self, from: responseData)
            for (value, key) in apiResponse.rates {
                let rate = RateModel(currency: value, value: key)
                ratesArray.append(rate)
            }
            ratesArray.sort { (obj1, obj2) -> Bool in
                obj1.currency < obj2.currency
            }
            let datasource = CurrencyDataSource()
            datasource.base = apiResponse.base
            datasource.date = apiResponse.date
            datasource.rates = ratesArray
            completion(datasource, nil)
        } catch {
            print(error)
            completion(nil, NetworkResponse.unableToDecode.rawValue)
        }
    }
}
