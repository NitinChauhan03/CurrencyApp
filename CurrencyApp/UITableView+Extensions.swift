//
//  UITableView+Extensions.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 28/02/22.
//

import Foundation
import UIKit

extension UITableView {

    // MARK: Register cell with nib
    func registerNib<T: UITableViewCell>(_: T.Type) {
        let nib = T.nib()
        self.register(nib, forCellReuseIdentifier: T.tableCellReuseIdentifier())
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.tableCellReuseIdentifier(), for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.tableCellReuseIdentifier())")
        }
        
        return cell
    }
}
