//
//  CustomButton.swift
//  CurrencyApp
//
//  Created by Nitin Chauhan on 24/02/22.
//

import Foundation
import UIKit

@IBDesignable class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        refreshCorners(value: cornerRadius)
        refreshBorderColor(_colorBorder: customBorderColor)
        refreshBorder(_borderWidth: borderWidth)
    }
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2 {
        didSet {
            refreshBorder(_borderWidth: borderWidth)
        }
    }

    func refreshBorder(_borderWidth: CGFloat) {
        layer.borderWidth = _borderWidth
    }

    @IBInspectable var customBorderColor: UIColor = UIColor.init (red: 0, green: 122/255, blue: 255/255, alpha: 1){
        didSet {
            refreshBorderColor(_colorBorder: customBorderColor)
        }
    }

    func refreshBorderColor(_colorBorder: UIColor) {
        layer.borderColor = _colorBorder.cgColor
    }
    
}
