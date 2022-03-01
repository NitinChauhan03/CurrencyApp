//
//  HeaderHistoryTableViewCell.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 01/03/22.
//

import UIKit
protocol HeaderHistoryTableViewCellProtocol : AnyObject{
    func didSelectDateFromList()
}


class HeaderHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var baseCurrencyLabel: UILabel!
    @IBOutlet weak var dateTextfield: UITextField!
    let pickerView = UIPickerView()
    var pickerDataSource = [String]()
    // MARK: Delegate
    weak var delegate : HeaderHistoryTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTapGestureOnDate()
        // Initialization code
    }

    func configure(_ uiconfig : UIConfigurationProtocol, baseCurrency : String, dateArray : [String]){
        dateTextfield.inputView = pickerView
        baseCurrencyLabel.text =  baseCurrency
        baseCurrencyLabel.textColor = uiconfig.textColor
        dateTextfield.textColor = uiconfig.themeColor
        dateTextfield.setBorder(color: uiconfig.themeColor ?? .blue)
        dateTextfield.text = dateArray.first
        pickerDataSource = dateArray
    }
    
    func addTapGestureOnDate()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HeaderHistoryTableViewCell.dateTapped))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.dateTextfield.addGestureRecognizer(tapGesture)
        self.dateTextfield.delegate = self
    }
    
    @objc func dateTapped() {
        
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.white
        pickerView.dataSource = self
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.gray
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(HeaderHistoryTableViewCell.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.dateTextfield.inputAccessoryView = toolBar
        self.dateTextfield.inputView = pickerView
        self.dateTextfield.reloadInputViews()
        self.dateTextfield.becomeFirstResponder()
    }
    @objc func doneClick() {
        self.endEditing(true)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension HeaderHistoryTableViewCell : UITextFieldDelegate{}

extension HeaderHistoryTableViewCell : UIPickerViewDelegate, UIPickerViewDataSource{
    // MARK: UIPickerView Delegation

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dateTextfield.text = pickerDataSource[row]
        CurrencyConvertorCache.shared.setDateSelected(date: pickerDataSource[row])
        delegate?.didSelectDateFromList()
    }
}
