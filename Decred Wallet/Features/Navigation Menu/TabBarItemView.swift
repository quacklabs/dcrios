//
//  TabBarItemView.swift
//  Decred Wallet
//
//  Created by Sprinthub on 26/08/2019.
//  Copyright © 2019 Decred. All rights reserved.
//

import UIKit
import Signals

public class TabBarItem{
    
    var title: String!
    var icon: UIImage!
    var controller: UIViewController?
    
    
    public init(icon:UIImage, title: String, controller: UIViewController?) {
        self.title = title
        self.icon = icon
        self.controller = controller
    }
    
    
}

public protocol TabBarItemDelegate: class{
    func itemTapped(index: Int)
}

class TabBarItemView: UIView{
    var item: TabBarItem!
    var titleLabel: UILabel!// = UILabel(frame: CGRect.zero)
    var iconView: UIImageView = UIImageView(frame: CGRect.zero)
    var font: UIFont = UIFont.systemFont(ofSize: 12)
    
    // Item index
    var index: Int
    weak var delegate: TabBarItemDelegate!
    
    
    private var selected = false{
        didSet{
            //do something to it here
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(_ item: TabBarItem, index: Int){
        self.item = item
        self.index = index

        super.init(frame: CGRect.zero)
        
        if let icon = self.item.icon {
            iconView.image = icon.withRenderingMode(.automatic)
            self.addSubview(iconView)
        }
        
        if let title = self.item.title {
            titleLabel = UILabel(frame: CGRect.zero)
            titleLabel.text = title
            titleLabel.font = self.font
            titleLabel.textColor = UIColor.black
            titleLabel.textAlignment = .center
            titleLabel.alpha = 1
            titleLabel.sizeToFit()
            addSubview(titleLabel)
        }
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.itemTapped)))
        backgroundColor = UIColor.white.withAlphaComponent(1)
    }
    
    
    @objc func itemTapped(_ gesture: UITapGestureRecognizer){
        self.delegate?.itemTapped(index: self.index)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: 19)
        iconView.frame = CGRect(x: self.frame.width / 2 - 13, y: 12, width: 26, height: 25)
    }
}
