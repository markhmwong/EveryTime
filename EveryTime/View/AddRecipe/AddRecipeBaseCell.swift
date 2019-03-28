//
//  AddRecipeBaseCell.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 22/1/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AddRecipeBaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        //
    }
}

class TableViewStep {
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    var name: String = ""
    var date: Date = Date()
    var priority: Int16 = 0
}
