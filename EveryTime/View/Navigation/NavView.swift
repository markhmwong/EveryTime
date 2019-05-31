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
    
    var topScreenAnchor: NSLayoutYAxisAnchor?
    
    private lazy var backgroundFiller: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Background.Color.NavBottomBorderColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, leftNavItem: UIButton? = nil, rightNavItem: UIButton? = nil, titleLabel: UILabel? = nil, topScreenAnchor: NSLayoutYAxisAnchor? = nil) {
        self.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leftNavItem = leftNavItem
        self.rightNavItem = rightNavItem
        self.titleLabel = titleLabel
        self.topScreenAnchor = topScreenAnchor
        self.setupView()
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
        addSubview(backgroundFiller)
    }

    override func layoutSubviews() {
        let borderThickness: CGFloat = 1.0
        bottomBorder.heightAnchor.constraint(equalToConstant: borderThickness).isActive = true
        bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorder.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomBorder.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        switch UIDevice.current.screenType.rawValue {
        case UIDevice.ScreenType.iPhoneXSMax.rawValue, UIDevice.ScreenType.iPhoneXR.rawValue, UIDevice.ScreenType.iPhoneX_iPhoneXS.rawValue:
            guard let topScreenAnchor = topScreenAnchor else { return }
            backgroundFiller.topAnchor.constraint(equalTo: topScreenAnchor, constant: 0.0).isActive = true
            backgroundFiller.bottomAnchor.constraint(equalTo: topAnchor, constant: 0.0).isActive = true
            backgroundFiller.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0).isActive = true
            backgroundFiller.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0).isActive = true
        default:
            ()
        }
    }
    
    func backgroundFillerColor(color: UIColor?) {
        backgroundFiller.backgroundColor = color
    }
}
