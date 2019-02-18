//
//  BaseCell.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 2/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class EntityBaseCell<E>: UICollectionViewCell {
    
    var entity: E?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        //
    }
    
}

class EntityBaseTableViewCell<E>: UITableViewCell {
    
    var entity: E?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        //
    }
    
}
