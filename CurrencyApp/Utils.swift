//
//  Utils.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 25/02/22.
//

import Foundation



typealias GenericClosure<T> = (T) -> Void


func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    debugPrint(items, separator: separator, terminator: terminator)
    #endif
}

func infoForKey(_ key: String) -> String? {
        return (Bundle.main.infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "")
 }



// localization
prefix operator &&

prefix func && (string: String?) -> String {
    guard let string = string else { return "" }
    return NSLocalizedString(string, comment: "")
}
