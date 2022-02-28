//
//  BaseModel.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 24/02/22.
//

import Foundation

public typealias NetworkManagerCompletion = (_ data: Data?,_ error: String?)->Swift.Void

protocol NetworkManagerProtocol {
    func getCurrenciesData(completion: @escaping NetworkManagerCompletion)
}

enum Result<String>{
    case success
    case failure(String)
}

struct NetworkManager : NetworkManagerProtocol{
    static let environment : NetworkEnvironment = .production
    let router = Router<CurrencyApi>()
    let dataHandling = DataHandling()
    
    func getCurrenciesData(completion: @escaping NetworkManagerCompletion){
        router.request(.getCurrenciessUri) { data, response, error in
            
            if error != nil {
                completion(nil, error?.localizedDescription)
            }
            
            dataHandling.responseHandling(data, response) { responseData, error in
                if error != nil{
                    completion(nil, NetworkResponse.noData.rawValue)
                }else{
                    completion(responseData, nil)
                }
            }
        }
    }
}
