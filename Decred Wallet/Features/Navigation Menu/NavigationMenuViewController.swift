//
//  NavigationMenuViewController.swift
//  Decred Wallet
//
// Copyright (c) 2018-2019 The Decred developers
// Use of this source code is governed by an ISC
// license that can be found in the LICENSE file.
import UIKit
import Dcrlibwallet

class NavigationMenuController: UITabBarController{
    
    var isNewWallet: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isNewWallet{
            let label =  UILabel(frame: CGRect(x: 129, y: 128, width: 117, height: 32))
            label.textAlignment = .center
            label.backgroundColor = UIColor.appColors.decredGreen
            label.font = UIFont.systemFont(ofSize: 16)
            label.text = LocalizedStrings.walletCreated
            label.textColor = UIColor.white
            label.layer.cornerRadius = 7
           
            
            UIView.animate(withDuration: 4.0){
                self.view.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = true
                label.clipsToBounds = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4){
                UIView.animate(withDuration: 3.0){
                    label.removeFromSuperview()
                }
            }
        }
        
        self.selectedIndex = 0
    }
    
    func changeActiveTab(to: MenuItem){
        self.selectedIndex = to.rawValue
    }
    
    
    static func setupMenuAndLaunchApp(isNewWallet: Bool){
        // wallet is open, setup sync listener and start notification listener
        AppDelegate.walletLoader.syncer.registerEstimatedSyncProgressListener()
        AppDelegate.walletLoader.notification.startListeningForNotifications()
        
        let startView = Storyboards.NavigationMenu.initialViewController()!
        
        
//        let navMenu = Storyboards.NavigationMenu.instantiateViewController(for: self)
//        self.isNewWallet = isNewWallet
        
        AppDelegate.shared.setAndDisplayRootViewController(startView)
        
    }
    
    
    
    
}
