//
//  CurrencyPickerViewController.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 25/02/22.
//

import UIKit
import RxSwift
import RxCocoa

protocol CurrencyPickerViewControllerProtocol : AnyObject{
    func didSelectCurrencyFromList(rateModel : RateModel)
}

class CurrencyPickerViewController: UIViewController {
    // MARK: View Model
    fileprivate var viewModel : CurrencyPickerViewModel!
    var disposeBag = DisposeBag()
    // MARK: UILabels
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    // MARK: Delegate
    weak var delegate : CurrencyPickerViewControllerProtocol?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var currencyList: UITableView!{
        didSet{
            self.currencyList.delegate = self
            self.currencyList.dataSource = self
            self.currencyList.registerNib(CurrencyTableViewCell.self)
        }
    }
    
    func configureViewModel(viewModel : CurrencyPickerViewModel){
        self.viewModel = viewModel
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
        self.dismiss(animated: true, completion: nil)
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.className) as? CurrencyTableViewCell{
            if let model = viewModel.getCurrenciesValueforRowIndex(index: indexPath.row) {
                cell.configure(model, uiconfig: viewModel.uiConfig)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = viewModel.getCurrenciesValueforRowIndex(index: indexPath.row) else { return }
        dismiss(animated: true) { [weak self] in
            if self?.delegate != nil{
                self?.delegate?.didSelectCurrencyFromList(rateModel: model)
            }
        }
    }
}


