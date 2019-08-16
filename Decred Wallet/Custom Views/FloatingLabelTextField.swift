//
//  FloatingLabelTextField.swift
//  Decred Wallet
//
//  Created by Sprinthub on 15/08/2019.
//  Copyright © 2019 Decred. All rights reserved.
//

import UIKit
import Signals


public protocol FloatingLabelTextFieldDelegate: class{
    func showFloatinglabel(text: String)
}

class FloatingLabelTextField: UITextField {
    
    
    var border = CALayer()
    var floatingLabel: UILabel!
    var placeHolderText: String?
    
    
    
    
    
    //weak var delegate: FloatingLabelTextFieldDelegate?
    
//    var isEditing: Signal = Signal<Bool>()
    
    @IBInspectable
    var floatingLabelColor: UIColor = UIColor.appColors.decredBlue {
        didSet {
            self.floatingLabel.textColor = floatingLabelColor
        }
    }
    
    @IBInspectable
    var floatingLabelFont: UIFont = UIFont.systemFont(ofSize: 14) {
    
        didSet {
            self.floatingLabel.font = floatingLabelFont
        }
    }
        
    var floatingLabelHeight: CGFloat = 14
    
    
    var button = UIButton(type: .custom)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
        
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        // Add the floating label
        let floatingLabelFrame = CGRect(x: 10, y: 0, width: self.frame.width, height: 0)
        floatingLabel = UILabel(frame: floatingLabelFrame)
        floatingLabel.textColor = floatingLabelColor
        floatingLabel.font = floatingLabelFont
        floatingLabel.backgroundColor = UIColor.white
        floatingLabel.text = self.placeholder
        
        self.addSubview(floatingLabel)
        placeHolderText = placeholder
        layer.borderWidth = 1.0
        borderStyle = .roundedRect;
        
        
        self.addTarget(self, action: #selector(self.addFloatingLabel), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
        
    }
    
    // Add a floating label here
    @objc func addFloatingLabel(){
        if self.text == "" {
            UIView.animate(withDuration: 0.23) {
                self.floatingLabel.frame = CGRect(x: 10, y: -10, width: self.frame.width, height: self.floatingLabelHeight)
                self.floatingLabel.sizeToFit()
            }
            self.placeholder = ""
        }
        layer.borderColor = UIColor.appColors.decredBlue.cgColor
    }
    
    
    
    
    //Remove floating label
    @objc func removeFloatingLabel(){
            if self.text == "" {
                UIView.animate(withDuration: 0.1) {
                    self.floatingLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
                }
                
                self.placeholder = placeHolderText
            }
        
        layer.borderColor = UIColor.appColors.darkGray.cgColor
    }
    
    func addViewPasswordButton(){
        button.setImage(UIImage(named: "icon-eye"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(self.frame.size.width - 22), y: CGFloat(16), width: CGFloat(22), height: CGFloat(16))
        
        button.addTarget(self, action: #selector(self.toggleSecureInput), for: .touchUpInside)
        rightView = button
        rightViewMode = .always
        
    }
    
    
    @objc func toggleSecureInput(){
        isSecureTextEntry.toggle()
    }
}
