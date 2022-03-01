//
//  UIStoryboard+Extensions.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 28/02/22.
//

import Foundation
import UIKit


extension UIStoryboard{
    fileprivate static let main = UIStoryboard(name: "Main", bundle: nil)
    
    func getViewController<T: UIViewController>() -> T {
        return instantiateViewController(withIdentifier: T.storyboardID) as! T
    }
    
    class func getCurrencyViewController(viewModel : CurrencyViewModel) -> CurrencyViewController {
        let viewController : CurrencyViewController = main.getViewController()
        viewController.configureViewModel(viewModel: viewModel)
        return viewController
    }
    class func getCurrencyPickerViewController(viewModel : CurrencyPickerViewModel) -> CurrencyPickerViewController {
        let viewController : CurrencyPickerViewController = main.getViewController()
        viewController.configureViewModel(viewModel: viewModel)
        return viewController
    }
    
    class func getHistoricalViewController(viewModel : HistoryViewModel) -> HistoricalViewController {
        let viewController : HistoricalViewController = main.getViewController()
        viewController.configureViewModel(viewModel: viewModel)
        return viewController
    }
}
