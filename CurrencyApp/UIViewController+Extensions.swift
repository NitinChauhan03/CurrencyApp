//
//  UIViewController+Extensions.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 28/02/22.
//

import Foundation
import UIKit

extension UIViewController {
    static var storyboardID: String {
        return className
    }
    
    func showAlert(title : String, message : String){
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok",
                                         style: .destructive) {(_: UIAlertAction) in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
