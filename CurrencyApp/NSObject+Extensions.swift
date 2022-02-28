//
//  NSObject+Extensions.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 28/02/22.
//

import Foundation
import UIKit

extension NSObject {
    static var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

