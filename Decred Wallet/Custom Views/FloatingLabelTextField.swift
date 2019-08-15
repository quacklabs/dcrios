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
    
    var floatingLabel: UILabel!
    var placeHolderText: String?
    
    //weak var delegate: FloatingLabelTextFieldDelegate?
    
//    var isEditing: Signal = Signal<Bool>()
    
    var floatingLabelColor: UIColor = UIColor.appColors.decredBlue {
        didSet {
            self.floatingLabel.textColor = floatingLabelColor
        }
    }
    var floatingLabelFont: UIFont = UIFont.systemFont(ofSize: 12) {
    
        didSet {
            self.floatingLabel.font = floatingLabelFont
        }
    }
        
    var floatingLabelHeight: CGFloat = 12
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
        
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
        let floatingLabelFrame = CGRect(x: 10, y: 0, width: frame.width, height: 0)
        floatingLabel = UILabel(frame: floatingLabelFrame)
        floatingLabel.textColor = floatingLabelColor
        floatingLabel.font = floatingLabelFont
//        floatingLabel.backgroundColor = UIColor.white
        floatingLabel.text = self.placeholder
        
        self.addSubview(floatingLabel)
        placeHolderText = placeholder
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: UITextField.textDidEndEditingNotification, object: self)
    
    
    }
        
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
    
        if self.text == "" {
            UIView.animate(withDuration: 0.3) {
                let yAxis: CGFloat = self.floatingLabelHeight
            self.floatingLabel.frame = CGRect(x: 8, y: -yAxis, width: self.frame.width, height: self.floatingLabelHeight)
            }
        self.placeholder = ""
        }
        
    }
        
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
    
        if self.text == "" {
        UIView.animate(withDuration: 0.1) {
        self.floatingLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
        }
        self.placeholder = placeHolderText
        }
        
       
    }
    deinit {
    
        NotificationCenter.default.removeObserver(self)
    
    }
}
//
//
//extension FloatingLabelTextField: FloatingLabelTextFieldDelegate{
//    func showFloatinglabel(text: String) {
//
//    }
//
//
//}



