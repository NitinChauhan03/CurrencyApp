//
//  Date+Extensions.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 01/03/22.
//

import Foundation

extension Date {
    static func getDates(forLastNDays nDays: Int) -> [String] {
        let cal = NSCalendar.current
        var date = cal.startOfDay(for: Date())
        var arrDates = [String]()
        for _ in 1 ... nDays {
            date = cal.date(byAdding: Calendar.Component.day, value: -1, to: date)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        return arrDates
    }
}
