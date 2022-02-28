//
//  Router.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 28/02/22.
//

import Foundation
import UIKit

class NavigationRouter{
    static func openCurrencyViewController() -> UIViewController?{
        let networkManager = NetworkManager()
        let uiConfig = UIConfiguration()
        let currencyDataSource = CurrencyDataSource()
        let parseManager = ParseManager()
        if let viewModel = CurrencyViewModel(networkManager: networkManager, uiConfig: uiConfig, dataSource: currencyDataSource, parseManager: parseManager){
            let currencyViewController = UIStoryboard.getCurrencyViewController(viewModel: viewModel)
            return currencyViewController
        }
        return nil
    }
    
    static func openCurrencyPickerViewController(withdelegate viewController : UIViewController, viewModel : CurrencyPickerViewModel){
        let currencyPickerVC = UIStoryboard.getCurrencyPickerViewController(viewModel: viewModel)
        currencyPickerVC.delegate = viewController as? CurrencyPickerViewControllerProtocol
        viewController.present(currencyPickerVC, animated: true, completion: nil)
    }
}
