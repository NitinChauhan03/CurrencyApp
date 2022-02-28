//
//  CurrencyEndPoint.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 25/02/22.
//

import Foundation

enum NetworkEnvironment {
    case debug
    case production
    case staging
}


public enum CurrencyApi{
    case getCurrenciessUri, getRatesUri
}

extension CurrencyApi: EndPointType {
    
    var positioningBaseURL : String {
        switch NetworkManager.environment {
        case .production, .debug, .staging: return infoForKey("API_URL") ?? Constants.URLs.apiBaseUrl
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: positioningBaseURL) else { fatalError("baseURL could not be configured.")}
        return url.appending(parameters) ?? url
    }
    
    var path: String {
        switch self {
        case .getCurrenciessUri:
            return "latest"
        case .getRatesUri:
            return "convert"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        return .request
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    var parameters: [URLQueryItem] {
        switch self {
        case .getCurrenciessUri, .getRatesUri:
            guard let key = accessKey else {
                assertionFailure("Missing accessKey")
                return []
            }
            return [URLQueryItem(name: "access_key", value: key)]
        }
    }
}

//MARK: Private variables/methods
private extension CurrencyApi {
    
    var accessKey: String? {
        guard let accessKey = infoForKey("ACCESS_KEY") else {
           return ""
        }
        return accessKey
    }
}
