//
//  DataHandlers.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 28/02/22.
//

import Foundation

class DataHandling{
    func responseHandling(_ data: Data?,_ response: URLResponse?, completion : NetworkManagerCompletion){
        
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
