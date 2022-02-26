//
//  ViewController.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 24/02/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapOnLetsStart(_ sender: Any) {
        let networkManager = NetworkManager()
        let uiConfig = UIConfiguration()
        let currencyDataSource = CurrencyDataSource()
        let parseManager = ParseManager()
        if let viewModel = CurrencyViewModel(networkManager: networkManager, uiConfig: uiConfig, dataSource: currencyDataSource, parseManager: parseManager){
            let currencyViewController = UIStoryboard.getCurrencyViewController(viewModel: viewModel)
            self.navigationController?.pushViewController(currencyViewController, animated: true)
        }
    }
    
}

