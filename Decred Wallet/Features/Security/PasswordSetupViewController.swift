//
//  PasswordSetupViewController.swift
//  Decred Wallet
//
// Copyright (c) 2018-2019 The Decred developers
// Use of this source code is governed by an ISC
// license that can be found in the LICENSE file.

import UIKit

class PasswordSetupViewController: SecurityBaseViewController, UITextFieldDelegate {
    // Input fields
    @IBOutlet weak var tfPassword: FloatingLabelTextField!
    @IBOutlet weak var tfConfirmPassword: FloatingLabelTextField!
    
    @IBOutlet weak var pbPasswordStrength: UIProgressView!
    
    @IBOutlet weak var passwordCount: UILabel!
    @IBOutlet weak var confirmCount: UILabel!
    
    // Buttons
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var createBtn: UIButton!
    
    // Error Labels
    @IBOutlet weak var passwordErr: UILabel!
    @IBOutlet weak var confirmErr: UILabel!
    
    
    var securityFor: String = "" // expects "Spending", "Startup" or other security section
    var onUserEnteredPassword: ((_ password: String) -> Void)?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnTapAround()
        
        self.setupInterface()
        
        // calculate password strength when password changes; and check if password matches
        self.tfPassword.addTarget(self, action: #selector(self.passwordTextFieldChange), for: .editingChanged)
        // add editing changed target to check if password matches
        self.tfConfirmPassword.addTarget(self, action: #selector(self.confirmPasswordTextFieldChange), for: .editingChanged)
        
        // display keyboard for input
        self.tfPassword.becomeFirstResponder()
        
        // set textfield delegates to move to next field or submit password on return key press
        self.tfPassword.delegate = self
        self.tfConfirmPassword.delegate = self
        
    }
    
    @objc func passwordTextFieldChange() {
        
        let passwordStrength = PinPasswordStrength.percentageStrength(of: self.tfPassword.text ?? "")
        pbPasswordStrength.progress = passwordStrength.strength
        pbPasswordStrength.progressTintColor = passwordStrength.color
        
        if self.tfPassword.text == ""{
            self.passwordCount.text = "\(0)"
        }else{
            self.passwordCount.text = "\(self.tfPassword.text!.count)"
        }
        
        self.checkPasswordMatch()
    }
    

    @objc func confirmPasswordTextFieldChange() {
        self.checkPasswordMatch()
    }
    
    func checkPasswordMatch() {
        
        createBtn.setBackgroundColor(UIColor.appColors.lightGray, for: .normal)
        
        if self.tfConfirmPassword.text == "" {
            self.confirmErr.textColor = UIColor.appColors.orangeWarning
            self.confirmErr.text = LocalizedStrings.passwordsDoNotMatch
            self.createBtn.isEnabled = false
            
        } else if self.tfPassword.text == self.tfConfirmPassword.text {
            self.confirmErr.textColor = UIColor.appColors.green
            self.confirmErr.text = LocalizedStrings.passwordMatch
            self.createBtn.isEnabled = true
            createBtn.setBackgroundColor(UIColor.appColors.decredBlue, for: .normal)
        } else {
            self.confirmErr.textColor = UIColor.appColors.orangeWarning
            self.confirmErr.text = LocalizedStrings.passwordsDoNotMatch
            self.createBtn.isEnabled = false
        }
        
        self.confirmCount.text = (self.tfConfirmPassword.text != "") ? "\(self.tfConfirmPassword.text!.count)" : "0"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.tfPassword {
            self.tfConfirmPassword.becomeFirstResponder()
            return true
        }
        
        return self.validatePasswordsAndProceed()
    }
    
    @IBAction func cancelTapped(_sender: UIButton){
        self.dismiss(animated: true)
    }
    
    @IBAction func createTapped(_ sender: UIButton){
        _ = self.validatePasswordsAndProceed()
    }
    
    
    func validatePasswordsAndProceed() -> Bool {
        let password = self.tfPassword.text ?? ""
        if password.length == 0 {
            self.showMessageDialog(title: LocalizedStrings.error, message: LocalizedStrings.emptyPasswordNotAllowed)
            return false
        }
        
        if self.tfPassword.text != self.tfConfirmPassword.text {
            self.showMessageDialog(title: LocalizedStrings.error, message: LocalizedStrings.passwordsDoNotMatch)
            return false
        }
        
        // only quit VC if not part of the SecurityVC tabs
        if self.tabBarController == nil {
            self.close()
        }
        
        self.onUserEnteredPassword?(self.tfPassword.text!)
        return true
    }
    
    private func close(){
        if self.isModal {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupInterface(){
        tfPassword.layer.cornerRadius = 7
        tfPassword.isSecureTextEntry = true
        tfPassword.addViewPasswordButton()
        
        tfConfirmPassword.layer.cornerRadius = 7
        tfConfirmPassword.isSecureTextEntry = true
        tfConfirmPassword.addViewPasswordButton()
        
        createBtn.layer.cornerRadius = 7
        
        
    }
}
