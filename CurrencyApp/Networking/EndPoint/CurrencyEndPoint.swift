//
//  CurrencyEndPoint.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 25/02/22.
//

import Foundation

enum NetworkEnvironment {
    case qa
    case production
    case staging
}


public enum CurrencyApi{
    case getCurrenciessUri, getRatesUri
}

extension CurrencyApi: EndPointType {
    
    var PositioningBaseURL : String {
        switch NetworkManager.environment {
        case .production, .qa, .staging: return Constants.URLs.apiBaseUrl
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: PositioningBaseURL) else { fatalError("baseURL could not be configured.")}
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
        guard let path = Bundle.main.path(forResource: "API", ofType: "plist"),
            let dictionary = NSDictionary(contentsOfFile: path) as? [String : String] else {
                return nil
        }
        return dictionary["AccessKey"]
    }
}
