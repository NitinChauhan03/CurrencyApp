//
//  BaseModel.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 24/02/22.
//

import Foundation

protocol NetworkManagerProtocol {
    func getCurrenciesData(completion: @escaping (_ data: Data?,_ error: String?) -> Swift.Void)
}

enum Result<String>{
    case success
    case failure(String)
}

struct NetworkManager : NetworkManagerProtocol{
    static let environment : NetworkEnvironment = .production
    let router = Router<CurrencyApi>()
    
    func getCurrenciesData(completion: @escaping (_ data: Data?,_ error: String?) -> Swift.Void){
        router.request(.getCurrenciessUri) { data, response, error in
            
            if error != nil {
                completion(nil, error?.localizedDescription)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    completion(responseData, nil)
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }

    // Error Codes
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 404 : return .failure(NetworkResponse.noresource.rawValue)
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
