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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.selectedIndex = 0
    }
    
    func changeActiveTab(to: MenuItem){
        self.selectedIndex = to.rawValue
    }
    
    
    static func setupMenuAndLaunchApp(isNewWallet: Bool){
        // wallet is open, setup sync listener and start notification listener
        AppDelegate.walletLoader.syncer.registerEstimatedSyncProgressListener()
        AppDelegate.walletLoader.notification.startListeningForNotifications()
        let defaultView = Storyboards.NavigationMenu.instantiateViewController(for: self)
        
        AppDelegate.shared.setAndDisplayRootViewController(defaultView)
        
    }
    
    
    
    
}
