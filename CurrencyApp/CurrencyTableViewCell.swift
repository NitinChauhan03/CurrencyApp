//
//  CurrencyTableViewCell.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 25/02/22.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(_ model: RateModel, uiconfig : UIConfigurationProtocol){
        currencyLbl.text =  model.currency
        rateLbl.text = "\(model.value)"
        currencyLbl.textColor = uiconfig.textColor
        rateLbl.textColor = uiconfig.themeColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
