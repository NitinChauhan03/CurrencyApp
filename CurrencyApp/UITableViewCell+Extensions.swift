//
//  UITableViewCell+Extensions.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 28/02/22.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    class func tableCellReuseIdentifier() -> String {
        return className
    }

}
