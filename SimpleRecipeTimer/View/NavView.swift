//
//  NavView.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 15/1/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class NavView: UIView {
    var leftNavItem: UIButton?
    var rightNavItem: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        
    }
}
