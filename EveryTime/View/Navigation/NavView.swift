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
    
    var titleLabel: UILabel?
    
    private lazy var bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Background.Color.NavBottomBorderColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, leftNavItem: UIButton? = nil, rightNavItem: UIButton? = nil, titleLabel: UILabel? = nil) {
        self.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leftNavItem = leftNavItem
        self.rightNavItem = rightNavItem
        self.titleLabel = titleLabel
        self.setupView()
        self.setupAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
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
        
        if let title = titleLabel {
            title.translatesAutoresizingMaskIntoConstraints = false
            addSubview(title)
            title.anchorView(top: nil, bottom: nil, leading: nil, trailing: nil, centerY: centerYAnchor, centerX: centerXAnchor, padding: .zero, size: .zero)
        }
        addSubview(bottomBorder)
    }
    
    private func setupAutoLayout() {
        let borderThickness: CGFloat = 1.0
        bottomBorder.heightAnchor.constraint(equalToConstant: borderThickness).isActive = true
        bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorder.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomBorder.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
