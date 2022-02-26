//
//  BaseViewModel.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 25/02/22.
//

import Foundation
import RxCocoa

protocol BaseViewModel: AnyObject {
    var shouldDisplayActivityIndicator: BehaviorRelay<Bool> { get set }
    var showErrorMessageContent: BehaviorRelay<String?> { get set }
}
