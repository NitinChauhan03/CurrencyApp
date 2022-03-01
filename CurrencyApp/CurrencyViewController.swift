//
//  CurrencyViewController.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 24/02/22.
//

import UIKit
import RxSwift
import RxCocoa


class CurrencyViewController: UIViewController {

    // MARK: Connections
    @IBOutlet weak var baseCurrencyBtnLabel: CustomButton!
    @IBOutlet weak var targetCurrencyBtnLabel: CustomButton!
    fileprivate let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    @IBOutlet weak var currencyInputField: UITextField!
    @IBOutlet weak var convertedField: UITextField!{
        didSet{
            convertedField.isUserInteractionEnabled = false
        }
    }
    // MARK: UILabel Collection
    @IBOutlet var displayLabelArray: [UILabel]!
    
    // MARK: View Model
    fileprivate var viewModel : CurrencyViewModel!
    fileprivate var disposeBag = DisposeBag()
    var numberToConvert = BehaviorRelay<Double>(value: 1.0)
    
    private enum CallingSource {
        case from
        case to
    }
    private var callingSource : CallingSource = .from
    
    
    
    func configureViewModel(viewModel : CurrencyViewModel){
        self.viewModel = viewModel
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getCurrencies()
        setupUI()
        self.navigationController?.navigationBar.isHidden = true
        bindActions()
    }
    func setupDisplayLabels(){
        for (index, value) in viewModel.getlabelValues().enumerated(){
            displayLabelArray[index].text = value
            displayLabelArray[index].textColor = self.viewModel.uiConfig.textColor
        }
    }
    func setupUI(){
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        baseCurrencyBtnLabel.setTitleColor(self.viewModel.uiConfig.textColor, for: .normal)
        targetCurrencyBtnLabel.setTitleColor(self.viewModel.uiConfig.textColor, for: .normal)
        baseCurrencyBtnLabel.refreshBorderColor(colorBorderVal: self.viewModel.uiConfig.textColor ?? .blue)
        targetCurrencyBtnLabel.refreshBorderColor(colorBorderVal: self.viewModel.uiConfig.textColor ?? .blue)
        currencyInputField.keyboardType = .decimalPad
        currencyInputField.setBorder(color: viewModel.uiConfig.themeColor ?? .blue)
        convertedField.setBorder(color: viewModel.uiConfig.themeColor ?? .blue)
        dismissTextfieldKeyBoard()
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
                        self.setupDisplayLabels()
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
        
        numberToConvert.asObservable().subscribe { [unowned self] value in
            setConvertedValue(number: numberToConvert.value)
        
        }.disposed(by: disposeBag)
        
        currencyInputField.rx.controlEvent([.editingDidBegin, .editingChanged, .editingDidEnd])
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                self.numberToConvert.accept(Double(self.currencyInputField.text ?? "1") ?? 1)
            })
            .disposed(by: disposeBag)
    }
    
    func setConvertedValue(number: Double){
        if let fromVal = baseCurrencyBtnLabel.titleLabel?.text, let toVal = targetCurrencyBtnLabel.titleLabel?.text{
            if  let convertedAmount = viewModel.getConvertedAmountToStr(from: fromVal, to: toVal, numberToConvert: number){
                convertedField.text = "\(convertedAmount)"
            }
        }
    }
    
    // MARK: Actions
    @IBAction func fromButtonClicked(_ sender: Any) {
        routerView(callingSource: .from)
    }
    @IBAction func toButtonclicked(_ sender: Any) {
        routerView(callingSource: .to)
    }
    @IBAction func swapCurrenciesButtonClicked(_ sender: Any) {
        self.currencyInputField.resignFirstResponder()
        self.viewModel.swapCurrency()
        self.updateCurrencies()
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func detailsBtnClicked(_ sender: Any) {
        if let viewModel = HistoryViewModel(networkManager: viewModel.networkManager, uiConfig: viewModel.uiConfig, dataSource: viewModel.dataSource, parseManager: viewModel.parseManager){
        NavigationRouter.openHistoricalViewController(from: self, viewModel: viewModel)
        }
    }
    
    private func routerView(callingSource : CallingSource){
        self.view.endEditing(true)
        self.callingSource = callingSource
        if let viewModel = CurrencyPickerViewModel(uiConfig: viewModel.uiConfig, dataSource: viewModel.dataSource){
            NavigationRouter.openCurrencyPickerViewController(withdelegate: self, viewModel: viewModel)
        }
    }
    
    func updateCurrencies(){
        if !self.viewModel.rateModelArray.isEmpty{
            let fromCurrency = self.viewModel.rateModelArray.first
            self.baseCurrencyBtnLabel.setTitle(fromCurrency?.currency, for: .normal)
        }
        if self.viewModel.rateModelArray.count > 1{
            let toCurrency = self.viewModel.rateModelArray.last
            self.targetCurrencyBtnLabel.setTitle(toCurrency?.currency, for: .normal)
        }
        if self.validateSelection(){
            if self.currencyInputField.text?.count ?? 0 < 1{
                self.currencyInputField.text = "1"
            }
            self.currencyInputField.becomeFirstResponder()
        }
    }
    
    private func validateSelection() -> Bool{
        if (self.viewModel.rateModelArray.count == 2){
           return true
        }
        return false
    }
    // MARK: Dismiss Keyboard
    func dismissTextfieldKeyBoard() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        currencyInputField.inputAccessoryView = toolBar
    }
    @objc func doneClick() {
        self.view.endEditing(true)
    }
}
extension CurrencyViewController : UITextFieldDelegate{ }

extension CurrencyViewController : CurrencyPickerViewControllerProtocol{
    func didSelectCurrencyFromList(rateModel: RateModel) {
        if self.callingSource == .from{
            self.viewModel.rateModelArray.insert(rateModel, at: 0)
        }
        else{
            self.viewModel.rateModelArray.insert(rateModel, at: 1)
        }
        self.updateCurrencies()
    }
}
