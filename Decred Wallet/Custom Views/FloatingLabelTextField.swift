//
//  FloatingLabelTextField.swift
//  Decred Wallet
//
//  Created by Sprinthub on 15/08/2019.
//  Copyright © 2019 Decred. All rights reserved.
//

import UIKit

class FloatingLabelTextField: UITextField {
    
    
    var border = CALayer()
    var floatingLabel: UILabel!
    var placeHolderText: String?
    
//    override var isSecureTextEntry: Bool = false
    
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
        
    var floatingLabelHeight: CGFloat? = 14
    
    let maxLabelSize: CGSize = CGSize(width: 1024, height: 1024)
    
    
    var button = UIButton(type: .custom)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
        
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        floatingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 0))
        placeHolderText = placeholder
        layer.borderWidth = 0.8
        borderStyle = .roundedRect;
        
        self.addTarget(self, action: #selector(self.addFloatingLabel), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
        
    }
    
    // Add a floating label here
    @objc func addFloatingLabel(){
        if self.text == "" {
            floatingLabel.textColor = floatingLabelColor
            floatingLabel.font = floatingLabelFont
            floatingLabel.text = self.placeholder
            floatingLabel.isOpaque = true
            floatingLabel.textAlignment = .center
            
            UIView.animate(withDuration: 0.4) {
                self.layer.borderColor = UIColor.appColors.decredBlue.cgColor
                self.floatingLabel.frame = CGRect(x: 10, y: -9, width: self.frame.width, height: self.floatingLabelHeight!)
                self.floatingLabel.layer.backgroundColor = UIColor.init(hex: "#FFFFFF").withAlphaComponent(1).cgColor
                self.floatingLabel.sizeToFit()
                self.addSubview(self.floatingLabel)
            }
            
            
            self.placeholder = ""
        }
        self.bringSubviewToFront(self.subviews.last!)
    }
    
    
    
    
    //Remove floating label
    @objc func removeFloatingLabel(){
            if self.text == "" {
                UIView.animate(withDuration: 0.1) {
                    self.subviews.forEach{ $0.removeFromSuperview() }
                    self.setNeedsDisplay()
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