//
//  Extensions.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 24/02/22.
//

import Foundation
import UIKit

extension NSObject {
    static var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UIViewController {
    static var storyboardID: String {
        return className
    }
}

extension UIStoryboard{
    fileprivate static let main = UIStoryboard(name: "Main", bundle: nil)
    
    func getViewController<T: UIViewController>() -> T {
        return instantiateViewController(withIdentifier: T.storyboardID) as! T
    }
    
    class func getCurrencyViewController(viewModel : CurrencyViewModel) -> CurrencyViewController {
        let vc : CurrencyViewController = main.getViewController()
        vc.viewModel = viewModel
        return vc
    }
    class func getCurrencyPickerViewController(viewModel : CurrencyPickerViewModel) -> CurrencyPickerViewController {
        let vc : CurrencyPickerViewController = main.getViewController()
        vc.viewModel = viewModel
        return vc
    }
}

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
extension UITableViewCell {
    
    class func tableCellReuseIdentifier() -> String {
        return className
    }

}
extension UIView{
    class func nib() -> UINib {
        return UINib(nibName: className, bundle: nil)
    }
}

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


extension URL {
    func appending(_ queryItems: [URLQueryItem]) -> URL? {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil
        }
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
        return urlComponents.url
    }
}
