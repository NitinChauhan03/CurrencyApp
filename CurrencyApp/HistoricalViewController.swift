//
//  HistoricalViewController.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 01/03/22.
//

import UIKit
import RxSwift
import RxCocoa

class HistoricalViewController: UIViewController {

    
    @IBOutlet weak var titlelabel: UILabel!
    var disposeBag = DisposeBag()
    fileprivate let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var numberToConvert = BehaviorRelay<Double>(value: 1.0)
    fileprivate var viewModel : HistoryViewModel!
    var headerCell: HeaderHistoryTableViewCell?
    @IBOutlet weak var historyList: UITableView!{
        didSet{
            self.historyList.delegate = self
            self.historyList.dataSource = self
            self.historyList.registerNib(CurrencyTableViewCell.self)
            self.historyList.registerNib(HeaderHistoryTableViewCell.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        titlelabel.text = viewModel.titleLabelValue
        titlelabel.textColor = self.viewModel.uiConfig.textColor
        bindActions()
    }
    func initialSetup(){
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        if let firstDate = viewModel.getDateArray().first {
            CurrencyConvertorCache.shared.setDateSelected(date: firstDate)
            viewModel.getHistoricalList()
        }
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
        
        viewModel.reloadData.asObservable().subscribe { shouldReload in
            if let shouldReload = shouldReload.element {
                DispatchQueue.main.async {
                    if shouldReload{
                        self.historyList.reloadData()
                    }
                }
            }
        }.disposed(by: disposeBag)
        
        viewModel.showErrorMessageContent.asObservable().subscribe(onNext: { message in
            if let errorMessage = message {
                DispatchQueue.main.async {
                    self.showAlert(title: &&"Error!", message: errorMessage )
                }
            }
        }).disposed(by: disposeBag)
    }
    func configureViewModel(viewModel : HistoryViewModel){
        self.viewModel = viewModel
    }
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension HistoricalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.getSectionCountDataSource().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRowsCountForSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.sections[indexPath.section] {
        case .headerSection:
            if let cell = tableView.dequeueReusableCell(withIdentifier: HeaderHistoryTableViewCell.className) as? HeaderHistoryTableViewCell{
                cell.configure(viewModel.uiConfig, baseCurrency: viewModel.getDefaultCurrencyFromUserDefaults(), dateArray: viewModel.getDateArray())
                cell.delegate = self
                self.headerCell = cell
                cell.selectionStyle = .none
                return cell
            }
            return UITableViewCell()
        case .currencies:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.className) as? CurrencyTableViewCell{
                if let model = viewModel.getCurrenciesValueforRowIndex(index: indexPath.row) {
                    cell.configure(model, uiconfig: viewModel.uiConfig)
                }
                return cell
            }
            return UITableViewCell()
        case .addMoreCurrencies:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Add More Currency"
            cell.textLabel?.textAlignment = .center
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.sections[indexPath.section] {
        case .addMoreCurrencies:
            if let viewModel = CurrencyPickerViewModel(uiConfig: viewModel.uiConfig, dataSource: viewModel.dataSource){
                NavigationRouter.openCurrencyPickerViewController(withdelegate: self, viewModel: viewModel)
            }
        case _:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.sections[indexPath.section] {
        case .headerSection:
            return 100
        case .addMoreCurrencies:
            return 70
        case _:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch viewModel.sections[indexPath.section] {
        case .currencies:
            return true
        case _:
            return false
        }
    }
}
extension HistoricalViewController : CurrencyPickerViewControllerProtocol{
    func didSelectCurrencyFromList(rateModel: RateModel) {
        CurrencyConvertorCache.shared.setCurrenciesToUserDefaults(currency: rateModel.currency)
        viewModel.getHistoricalList()
    }
}
extension HistoricalViewController : HeaderHistoryTableViewCellProtocol{
    func didSelectDateFromList(){
        viewModel.getHistoricalList()
    }
}
