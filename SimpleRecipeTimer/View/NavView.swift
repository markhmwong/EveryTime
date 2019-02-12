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
        
        var bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        layer.addSublayer(bottomLine)
    }
    
    func setupAutoLayout() {
        guard let left = leftNavItem else {
            return
        }
        
    }
}
