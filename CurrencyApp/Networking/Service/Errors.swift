//
//  Errors.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 26/02/22.
//

import Foundation

enum NetworkResponse:String {
    case success
    case noresource = "The requested resource does not exist."
    case noApiKey = "No API Key was specified or an invalid API Key was specified."
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    
}
