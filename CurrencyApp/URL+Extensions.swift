//
//  URL+Extensions.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 28/02/22.
//

import Foundation
import UIKit



extension URL {
    func appending(_ queryItems: [URLQueryItem]) -> URL? {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil
        }
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
        return urlComponents.url
    }
}
