//
//  UIConfiguration.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 24/02/22.
//

import Foundation
import UIKit

protocol UIConfigurationProtocol {
    var defaultInitialValue: Int64? {get}
    var textColor : UIColor? {get}
    var homeTitle : String? {get}
    var selectionTitle : String? {get}
    var themeColor : UIColor? {get}
}

class UIConfiguration: UIConfigurationProtocol {
    var defaultInitialValue: Int64? {
        return 1
    }
    var textColor: UIColor? {
        return UIColor.init(red: 0, green: 121/255, blue: 242/255, alpha: 1)
    }
    
    var homeTitle : String?{
        return Constants.StringConstants.homeTitle
    }
    var selectionTitle : String?{
        return Constants.StringConstants.titleName
    }
    var themeColor : UIColor? {
        return UIColor.init(red: 0, green: 205/255, blue: 128/255, alpha: 1)
    }
}
