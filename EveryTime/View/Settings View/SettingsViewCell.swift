//
//  AboutViewCell.swift
//  EveryTime
//
//  Created by Mark Wong on 24/3/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class SettingsViewCell: UITableViewCell {
    var theme: ThemeManager?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(theme: ThemeManager, reuseIdentifier: String?) {
        self.init()
//        self.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.theme = theme
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLabel(text: String) {
        self.textLabel?.attributedText = NSAttributedString(string: text, attributes: self.theme?.currentTheme.tableView.settingsCell)
    }
}
