//
//  TableViewDataSource.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 25/02/22.
//

import Foundation

protocol CurrencyDataSourceProtocol: AnyObject {
    var base: String? {get set}
    var date: String? {get set}
    var rates: [RateModel]? {get set}
    var selectedRates: [RateModel]? {get set}
    func getSectionCount() -> Int
    func getRowCount() -> Int?
}

class CurrencyDataSource : CurrencyDataSourceProtocol{
    var base: String?
    var date: String?
    var rates: [RateModel]?
    var selectedRates: [RateModel]?
    
    func getSectionCount() -> Int{
        return 1
    }
    func getRowCount() -> Int?{
        return rates?.count
    }
    
    
}
