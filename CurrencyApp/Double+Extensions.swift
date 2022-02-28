//
//  Double+Extensions.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 28/02/22.
//

import Foundation
import UIKit


extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
