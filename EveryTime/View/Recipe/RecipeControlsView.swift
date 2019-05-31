//
//  RecipeControlsView.swift
//  EveryTime
//
//  Created by Mark Wong on 22/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class RecipeControlsView: UIView {
    
    var delegate: RecipeViewControllerWithTableView?
    
    var theme: ThemeManager?
    
    private lazy var additionalTimeButton: StandardButton = {
        let button = StandardButton(title: "+15", theme: theme)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(handleAdditionalTime), for: .touchUpInside)
        return button
    }()
    
    private lazy var subtractTimeButton: StandardButton = {
        let button = StandardButton(title: "-15", theme: theme)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(handleMinusTime), for: .touchUpInside)
        return button
    }()
    
    private lazy var resetTimeButton: StandardButton = {
        let button = StandardButton(title: "Reset", theme: theme)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(handleResetStepTime), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(delegate: RecipeViewControllerWithTableView, theme: ThemeManager?) {
        self.init(frame: .zero)
        self.delegate = delegate
        self.theme = theme
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = theme?.currentTheme.button.backgroundColor
        
        additionalTimeButton.isEnabled = false
        additionalTimeButton.alpha = 0.4
        resetTimeButton.isEnabled = false
        resetTimeButton.alpha = 0.4
        subtractTimeButton.isEnabled = false
        subtractTimeButton.alpha = 0.4
        
        addSubview(resetTimeButton)
        addSubview(additionalTimeButton)
        addSubview(subtractTimeButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let screenSize = UIScreen.main.bounds.size
        additionalTimeButton.trailingAnchor.constraint(equalTo: leadingAnchor, constant: (screenSize.width / 8) * 2).isActive = true
        additionalTimeButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.0).isActive = true
        additionalTimeButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
        
        resetTimeButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0.0).isActive = true
        resetTimeButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.0).isActive = true
        resetTimeButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
        
        subtractTimeButton.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -(screenSize.width / 8) * 2).isActive = true
        subtractTimeButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.0).isActive = true
        subtractTimeButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
    }
    
    func enableStepOptions() {
        additionalTimeButton.isEnabled = true
        resetTimeButton.isEnabled = true
        subtractTimeButton.isEnabled = true
        additionalTimeButton.alpha = 1.0
        resetTimeButton.alpha = 1.0
        subtractTimeButton.alpha = 1.0
    }
    
    @objc func handleAdditionalTime() {
        if let delegate = delegate {
            delegate.handleAdditionalTime()
        }
    }
    
    @objc func handleResetStepTime() {
        if let delegate = delegate {
            delegate.handleResetStepTime()
        }
    }
    
    @objc func handleMinusTime() {
        if let delegate = delegate {
            delegate.handleMinusTime()
        }
    }
}
