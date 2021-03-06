//
//  TransactionTableViewCell.swift
//  Decred Wallet
//
// Copyright (c) 2018-2020 The Decred developers
// Use of this source code is governed by an ISC
// license that can be found in the LICENSE file.

import UIKit
import Dcrlibwallet

class TransactionTableViewCell: UITableViewCell {
    @IBOutlet weak var dataImage: UIImageView!
    @IBOutlet weak var dataText: UILabel!
    @IBOutlet weak var status: UILabel!
   // @IBOutlet weak var dateT: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    
    var count = 0
    
    override func awakeFromNib() {}
    
    override class func height() -> CGFloat {
        return 56
    }
    
    func setData(_ data: Any?) {
        if let transaction = data as? Transaction {
            var confirmations: Int32 = 0
            if transaction.blockHeight != -1 {
                confirmations = WalletLoader.shared.firstWallet!.getBestBlock() - Int32(transaction.blockHeight) + 1
            }
            let Date2 = NSDate.init(timeIntervalSince1970: TimeInterval(transaction.timestamp) )
                      let dateformater = DateFormatter()
                      dateformater.locale = Locale(identifier: "en_US_POSIX")
                      dateformater.dateFormat = "MMM dd"
                      dateformater.string(from: Date2 as Date)
                      
                     // self.dateT.text = dateformater.string(from: Date2 as Date)
            
            let isConfirmed = Settings.spendUnconfirmed || confirmations > 1
            self.status.text = isConfirmed ? dateformater.string(from: Date2 as Date) : LocalizedStrings.pending
            self.status.textColor = isConfirmed ? UIColor(hex:"#596d81") : UIColor(hex:"#8997a5")
            self.statusIcon.image = isConfirmed ? UIImage(named: "confirmed") : UIImage(named: "pending")
            
          
            let requireConfirmation = Settings.spendUnconfirmed ? 0 : 2
            
            if transaction.type == DcrlibwalletTxTypeRegular {
                if transaction.direction == DcrlibwalletTxDirectionSent {
                    let attributedString = NSMutableAttributedString(string: "-")
                    attributedString.append(Utils.getAttributedString(str: transaction.dcrAmount.round(8).description, siz: 13.0, TexthexColor: UIColor.appColors.darkBlue))
                    self.dataText.attributedText = attributedString
                    self.dataImage?.image = UIImage(named: "debit")
                } else if transaction.direction == DcrlibwalletTxDirectionReceived {
                    let attributedString = NSMutableAttributedString(string: " ")
                    attributedString.append(Utils.getAttributedString(str: transaction.dcrAmount.round(8).description, siz: 13.0, TexthexColor: UIColor.appColors.darkBlue))
                    self.dataText.attributedText = attributedString
                    self.dataImage?.image = UIImage(named: "credit")
                } else if transaction.direction == DcrlibwalletTxDirectionTransferred {
                    let attributedString = NSMutableAttributedString(string: " ")
                    attributedString.append(Utils.getAttributedString(str: transaction.dcrAmount.round(8).description, siz: 13.0, TexthexColor: UIColor.appColors.darkBlue))
                    self.dataText.attributedText = attributedString
                    self.dataImage?.image = UIImage(named: "fee")
                }
            } else if transaction.type == DcrlibwalletTxTypeVote {
                self.dataText.text = " \(LocalizedStrings.vote)"
                self.dataImage?.image = UIImage(named: "vote")
            } else if transaction.type == DcrlibwalletTxTypeTicketPurchase {
                self.dataText.text = " \(LocalizedStrings.ticket)"
                self.dataImage?.image = UIImage(named: "immature")
                
                if confirmations < requireConfirmation {
                    self.status.textColor = UIColor(hex:"#3d659c")
                    self.status.text = LocalizedStrings.pending
                } else if confirmations > BuildConfig.TicketMaturity {
                    let statusText = LocalizedStrings.confirmedLive
                    let range = (statusText as NSString).range(of: "/")
                    let attributedString = NSMutableAttributedString(string: statusText)
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range)
                    self.status.textColor = UIColor(hex:"#2DD8A3")
                    self.status.attributedText = attributedString
                    self.dataImage?.image = UIImage(named: "live")
                } else {
                    let statusText = LocalizedStrings.confirmedImmature
                    let range = (statusText as NSString).range(of: "/")
                    let attributedString = NSMutableAttributedString(string: statusText)
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range)

                    self.status.textColor = UIColor.orange
                    self.status.attributedText = attributedString
                    self.dataImage?.image = UIImage(named: "immature")
                }
            }
        }
    }
}
