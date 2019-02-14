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
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, leftNavItem: UIButton? = nil, rightNavItem: UIButton? = nil) {
        self.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = Theme.Background.Color.NavBackgroundColor
        self.leftNavItem = leftNavItem
        self.rightNavItem = rightNavItem
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {        
        if let left = leftNavItem {
            left.translatesAutoresizingMaskIntoConstraints = false
            addSubview(left)
            left.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
            left.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }

        if let right = rightNavItem {
            right.translatesAutoresizingMaskIntoConstraints = false
            addSubview(right)
            right.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
            right.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
        
        let bottomBorder = UIView()
        let gray: CGFloat = 100.0
        let borderThickness: CGFloat = 2.0
        bottomBorder.backgroundColor = UIColor(red: gray / 255.0, green: gray / 255.0, blue: gray / 255.0, alpha: 1.0)
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomBorder)
        
        bottomBorder.heightAnchor.constraint(equalToConstant: borderThickness).isActive = true
        bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorder.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomBorder.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    fileprivate func setupAutoLayout() {

        
    }
}
