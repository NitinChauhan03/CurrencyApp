//
//  CurrencyPickerViewController.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 25/02/22.
//

import UIKit
import RxSwift
import RxCocoa

class CurrencyPickerViewController: UIViewController {
  
    var selectionHandler: GenericClosure<RateModel?>?
    // MARK: View Model
    var viewModel : CurrencyPickerViewModel!
    var disposeBag = DisposeBag()
    // MARK: UILabels
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var currencyList: UITableView!{
        didSet{
            self.currencyList.delegate = self
            self.currencyList.dataSource = self
            self.currencyList.registerNib(CurrencyTableViewCell.self)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCurrencyList()
        bindActions()
        // Do any additional setup after loading the view.
    }
    func setupCurrencyList() {
        titlelabel.text = viewModel.titleLabelValue
        datelabel.text = self.viewModel.todayDate
        titlelabel.textColor = self.viewModel.uiConfig.textColor
        datelabel.textColor = self.viewModel.uiConfig.textColor
        currencyList.tableFooterView = UIView()
    }
    
    func bindActions() {
        
        viewModel.shouldDisplayActivityIndicator.asObservable().subscribe { shouldShow in
            if let shouldShow = shouldShow.element {
                DispatchQueue.main.async {
                    if shouldShow {
                        self.activityIndicator.startAnimating()
                    } else {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidesWhenStopped = true
                    }
                }
            }
        }.disposed(by: disposeBag)
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.selectionHandler?(nil)
        }
    }
}
extension CurrencyPickerViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getSectionCountDataSource()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRowsCountForSection(index: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.className) as! CurrencyTableViewCell
        if let model = viewModel.getCurrenciesValueforRowIndex(index: indexPath.row) {
            cell.configure(model, uiconfig: viewModel.uiConfig)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = viewModel.getCurrenciesValueforRowIndex(index: indexPath.row) else { return }
        dismiss(animated: true) { [weak self] in
            self?.selectionHandler?(model)
        }
    }
}
