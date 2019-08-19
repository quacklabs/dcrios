//
//  MenuItems.swift
//  Decred Wallet
//
// Copyright (c) 2018-2019 The Decred developers
// Use of this source code is governed by an ISC
// license that can be found in the LICENSE file.

import UIKit

enum MenuItem: Int, CaseIterable {
    
    case overview = 0
    case transactions = 1
    case accounts = 2
    case more = 3
    
    var icon: UIImage? {
        switch self {
        case .overview:
            return UIImage(named: "ic_overview01_24px")
            
        case .transactions:
            return UIImage(named: "ic_transactions02_24px")
            
        case .accounts:
            return UIImage(named: "ic_accounts02_24px")
        
        case .more:
            return UIImage(named: "ic_menu2_24px")
  
        }
    }
    
//    var displayTitle: String {
//        return NSLocalizedString(self.rawValue.lowercased(), comment: "")
//    }
}
