//
//  TransactionHistoryViewController.swift
//  Decred Wallet
//
// Copyright (c) 2018-2019 The Decred developers
// Use of this source code is governed by an ISC
// license that can be found in the LICENSE file.

import UIKit

class TransactionHistoryViewController: UIViewController {
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(TransactionHistoryViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.lightGray
        
        return refreshControl
    }()
    
    var currentFilter: Int32? = 0
    
    @IBOutlet weak var syncLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnFilter: DropMenuButton!
    var FromMenu = true
    var visible:Bool = false
    
    var filterMenu = [LocalizedStrings.all] as [String]
    var filtertitle = [0] as [Int]
    
    var Filtercontent = [Transaction]()
    var transactions = [Transaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initFilterBtn()
        self.tableView.addSubview(self.refreshControl)
        self.tableView.register(UINib(nibName: TransactionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TransactionTableViewCell.identifier)

        AppDelegate.walletLoader.notification.registerListener(for: "(\(self)", newTxistener: self)
        AppDelegate.walletLoader.notification.registerListener(for: "(\(self)", confirmedTxListener: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar(withTitle: LocalizedStrings.history)

        if AppDelegate.walletLoader.isSynced {
            print(" wallet is synced on history")
            self.syncLabel.isHidden = true
            self.tableView.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !AppDelegate.walletLoader.isSynced {
            print(" wallet not synced on history")
            return
        }
        self.visible = true
        if (self.FromMenu){
            refreshControl.showLoader(in: self.tableView)
            loadTransactions()
            FromMenu = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.visible = false
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.reloadTxsForCurrentFilter()
    }
    
    func loadTransactions(filter: Int? = 0) {
        self.transactions.removeAll()
        var error: NSError?
        let allTransactions = AppDelegate.walletLoader.wallet?.getTransactions(0, txFilter: Int32(filter!), error: &error)
        if error != nil || allTransactions == nil || allTransactions!.count == 0{
            self.showNoTransactions()
            return
        }
        
        self.transactions = try! JSONDecoder().decode([Transaction].self, from: allTransactions!.data(using: .utf8)!)
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = .singleLine
        self.refreshControl.endRefreshing()
        self.updateFilterDropdownItems()
        return
    }
    
    func showNoTransactions() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
        label.text = LocalizedStrings.noTransactions
        label.textAlignment = .center
        self.tableView.backgroundView = label
        self.tableView.separatorStyle = .none
    }
    
    func initFilterBtn() {
        self.btnFilter.initMenu(filterMenu) { [weak self] index, value in
            self?.applyTxFilter(currentFilter: self!.filtertitle[index])
        }
    }
    
    func reloadTxsForCurrentFilter() {
        var currentFilterItem = 0
        if self.btnFilter.selectedItemIndex >= 0 && self.filtertitle.count > self.btnFilter.selectedItemIndex {
            currentFilterItem = self.filtertitle[self.btnFilter.selectedItemIndex]
        }
        self.applyTxFilter(currentFilter: currentFilterItem)
    }
    
    func applyTxFilter(currentFilter: Int) {
        var filterCount: Int? = 0
        switch currentFilter {
            case 1:
                filterCount = transactions.filter{$0.Direction == 0 && $0.Type == GlobalConstants.Strings.REGULAR}.count
                self.btnFilter.setTitle(LocalizedStrings.sent.appending("(\(filterCount!))"), for: .normal)
                break
            case 2:
                filterCount = self.transactions.filter{$0.Direction == 1 && $0.Type == GlobalConstants.Strings.REGULAR}.count
            self.btnFilter.setTitle(LocalizedStrings.received.appending("(\(filterCount!))"), for: .normal)
            break
        case 3:
            filterCount = self.transactions.filter{$0.Direction == 2 && $0.Type == GlobalConstants.Strings.REGULAR}.count
            self.btnFilter.setTitle(LocalizedStrings.yourself.appending("(\(filterCount!))"), for: .normal)
            break
        case 4:
            filterCount = self.transactions.filter{$0.Type == GlobalConstants.Strings.REVOCATION || $0.Type == GlobalConstants.Strings.TICKET_PURCHASE || $0.Type == GlobalConstants.Strings.VOTE}.count
            self.btnFilter.setTitle(LocalizedStrings.staking.appending("(\(filterCount!))"), for: .normal)
            break
        case 5:
            filterCount = self.transactions.filter{$0.Type == GlobalConstants.Strings.COINBASE}.count
            self.btnFilter.setTitle("Coinbase \(filterCount!)", for: .normal)
            break
        default:
            filterCount = self.transactions.count
            self.btnFilter.setTitle(LocalizedStrings.all.appending("(\(self.transactions.count))"), for: .normal)
        }
        
        refreshControl.showLoader(in: self.tableView)
        self.loadTransactions(filter: currentFilter)
        self.tableView.reloadData()
    }
    
    func updateFilterDropdownItems() {
        let sentCount = self.transactions.filter{$0.Direction == 0}.count
        let ReceiveCount = self.transactions.filter{$0.Direction == 1}.count
        let yourselfCount = self.transactions.filter{$0.Direction == 2}.count
        let stakeCount = self.transactions.filter{$0.Type.lowercased() != "Regular".lowercased()}.count
        let coinbaseCount = self.transactions.filter{$0.Type == GlobalConstants.Strings.COINBASE}.count
        
        self.btnFilter.items.removeAll()
        self.btnFilter.setTitle(LocalizedStrings.all.appending("(\(self.transactions.count))"), for: .normal)
        self.btnFilter.items.append(LocalizedStrings.all.appending("(\(self.transactions.count))"))
        
        self.filtertitle.removeAll()
        self.filtertitle.append(0)
        
        if sentCount != 0 {
            self.btnFilter.items.append(LocalizedStrings.sent.appending("(\(sentCount))"))
            self.filtertitle.append(1)
        }
        if ReceiveCount != 0 {
            self.btnFilter.items.append(LocalizedStrings.received.appending("(\(ReceiveCount))"))
            self.filtertitle.append(2)
        }
        if yourselfCount != 0 {
            self.btnFilter.items.append(LocalizedStrings.yourself.appending("(\(yourselfCount))"))
            self.filtertitle.append(3)
        }
        if stakeCount != 0 {
            self.btnFilter.items.append(LocalizedStrings.staking.appending("(\(stakeCount))"))
            self.filtertitle.append(4)
        }
        if coinbaseCount != 0 {
            self.btnFilter.items.append("Coinbase (\(coinbaseCount))")
            self.filtertitle.append(5)
        }
        
    }
}

extension TransactionHistoryViewController: NewTransactionNotificationProtocol, ConfirmedTransactionNotificationProtocol {
    func onTransaction(_ transaction: String?) {
        var tx = try! JSONDecoder().decode(Transaction.self, from:(transaction!.utf8Bits))
        
        if self.transactions.contains(where: { $0.Hash == tx.Hash }) {
            // duplicate notification, tx is already being displayed in table
            return
        }
        
        tx.Animate = true
        self.transactions.insert(tx, at: 0)
        
        // Save hash for this tx as last viewed tx hash.
        Settings.setValue(tx.Hash, for: Settings.Keys.LastTxHash)
        
        DispatchQueue.main.async {
            self.reloadTxsForCurrentFilter()
        }
    }
    
    func onTransactionConfirmed(_ hash: String?, height: Int32) {
        DispatchQueue.main.async {
            self.loadTransactions()
        }
    }
}

extension TransactionHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TransactionTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier) as! TransactionTableViewCell
        cell.setData(transactions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.transactions.count > indexPath.row{
            if self.transactions[indexPath.row].Animate{
                cell.blink()
            }
            
            self.transactions[indexPath.row].Animate = false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "TransactionFullDetailsViewController", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "TransactionFullDetailsViewController") as! TransactionFullDetailsViewController
        if self.transactions.count == 0{
            return
        }
        self.FromMenu = false
        subContentsVC.transaction = self.transactions[indexPath.row]
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
}
