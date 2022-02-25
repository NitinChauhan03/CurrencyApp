//
//  TableViewDataSource.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 25/02/22.
//

import Foundation

protocol TableViewDataSourceProtocol: AnyObject {
    var base: String? {get set}
    var date: String? {get set}
    var rates: [RateModel]? {get set}
    func getSectionCount() -> Int
    func getRowCount() -> Int?
}

class TableViewDataSource : TableViewDataSourceProtocol{
    var base: String?
    var date: String?
    var rates: [RateModel]?
    
    func getSectionCount() -> Int{
        return 1
    }
    func getRowCount() -> Int?{
        return rates?.count
    }
}
