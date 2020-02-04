//
//  Wallet.swift
//  Decred Wallet
//
// Copyright (c) 2020 The Decred developers
// Use of this source code is governed by an ISC
// license that can be found in the LICENSE file.

import Foundation
import Dcrlibwallet

class Wallet: NSObject {
    private(set) var id: Int
    private(set) var name: String
    private(set) var balance: String
    private(set) var accounts = [DcrlibwalletAccount]()
    private(set) var isSeedBackedUp: Bool = false
    private(set) var displayAccounts: Bool = false
    
    init(_ wallet: DcrlibwalletWallet) {
        self.id = wallet.id_
        self.name = wallet.name
        self.balance = "\(wallet.totalWalletBalance()) DCR"
        self.accounts = wallet.accounts(confirmations: 0)
        self.isSeedBackedUp = wallet.seed.isEmpty
        self.displayAccounts = false
    }
    
    func toggleAccountsDisplay() {
        self.displayAccounts = !self.displayAccounts
    }
}