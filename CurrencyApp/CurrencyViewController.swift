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
    @IBOutlet weak var fromButton: CustomButton!
    @IBOutlet weak var toButton: CustomButton!
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    @IBOutlet weak var currencyInputField: UITextField!{
        didSet{
            currencyInputField.addTarget(self, action: #selector(CurrencyViewController.textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    @IBOutlet weak var convertedField: UITextField!{
        didSet{
            convertedField.isUserInteractionEnabled = false
        }
    }
    // MARK: UILabels
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    // MARK: View Model
    var viewModel : CurrencyViewModel!
    var disposeBag = DisposeBag()
    var numberToConvert = BehaviorRelay<Double>(value: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getCurrenciesData { success in
            print(success)
        }
        titlelabel.text = viewModel.titleLabelValue
        datelabel.text = self.viewModel.todayDate
        titlelabel.textColor = self.viewModel.uiConfig.textColor
        datelabel.textColor = self.viewModel.uiConfig.textColor
        setupUI()
        self.navigationController?.navigationBar.isHidden = true
        bindActions()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        fromButton.setTitleColor(self.viewModel.uiConfig.textColor, for: .normal)
        toButton.setTitleColor(self.viewModel.uiConfig.textColor, for: .normal)
        fromButton.refreshBorderColor(_colorBorder: self.viewModel.uiConfig.textColor)
        toButton.refreshBorderColor(_colorBorder: self.viewModel.uiConfig.textColor)
        currencyInputField.layer.cornerRadius = 5
        currencyInputField.layer.borderWidth = 1
        currencyInputField.layer.borderColor = viewModel.uiConfig.themeColor.cgColor
        currencyInputField.keyboardType = .decimalPad
        convertedField.layer.cornerRadius = 5
        convertedField.layer.borderWidth = 1
        convertedField.layer.borderColor = viewModel.uiConfig.themeColor.cgColor
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
        
        
        numberToConvert.asObservable().subscribe { [unowned self] value in
            setConvertedValue(number: numberToConvert.value)
        
        }.disposed(by: disposeBag)
        
//        viewModel.reloadLst.asObservable().subscribe { [unowned self] shouldReload in
//            if let shouldReload = shouldReload.element {
//                DispatchQueue.main.async {
//                    if shouldReload {
//                        self.currencyList.reloadData()
//                    }
//                }
//            }
//        }.disposed(by: disposeBag)
        
        currencyInputField.rx.controlEvent([.editingChanged, .editingDidEnd])
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                self.numberToConvert.accept(Double(self.currencyInputField.text ?? "1") ?? 1)
            })
            .disposed(by: disposeBag)
    }
    
    func setConvertedValue(number: Double){
        let convertedAmount = viewModel.getConvertedAmountToStr(from: fromButton.titleLabel?.text, to: toButton.titleLabel?.text , numberToConvert: number)
        convertedField.text = "\(convertedAmount)"
    }
    
    
    // MARK: Actions
    @IBAction func fromButtonClicked(_ sender: Any) {
        routerView(callingSource: .from)
    }
    @IBAction func toButtonclicked(_ sender: Any) {
        routerView(callingSource: .to)
    }
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func routerView(callingSource : CallingSource){
        self.view.endEditing(true)
        let networkManager = NetworkManager()
        let uiConfig = UIConfiguration()
        if let viewModel = CurrencyPickerViewModel(networkManager: networkManager, uiConfig: uiConfig, dataSource: viewModel.dataSource){
            let currencyPickerVC = UIStoryboard.getCurrencyPickerViewController(viewModel: viewModel)
            currencyPickerVC.selectionHandler = { [weak self] rateModel in
                guard let sSelf = self , let _rateModel = rateModel else { return }
                if callingSource == .from{
                    sSelf.fromButton.setTitle(_rateModel.currency, for: .normal)
                }else{
                    sSelf.toButton.setTitle(_rateModel.currency, for: .normal)
                }
                
            }
            self.present(currencyPickerVC, animated: true, completion: nil)
        }
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
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
