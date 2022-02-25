//
//  SymbolsModel.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 24/02/22.
//

import Foundation

struct ExchangeRatesModel: GenericBaseModel {
    let base: String
    let date: String
    let rates: [String: Double]
}
