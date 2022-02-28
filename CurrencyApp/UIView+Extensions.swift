//
//  UIView+Extensions.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 28/02/22.
//

import Foundation
import UIKit


extension UIView{
    class func nib() -> UINib {
        return UINib(nibName: className, bundle: nil)
    }
}
