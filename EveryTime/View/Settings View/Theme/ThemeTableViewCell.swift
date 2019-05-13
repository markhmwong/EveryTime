//
//  ThemeTableViewCell.swift
//  EveryTime
//
//  Created by Mark Wong on 7/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit


/// Set this class up for UIAppearance
class ThemeTableViewCell: UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {

    }
    
}

class ThemeCellLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
