//
//  EmptyCollectionView.swift
//  EveryTime
//
//  Created by Mark Wong on 26/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class EmptyCollectionView: UIView {
    
    var theme: ThemeManager?
    
    var delegate: MainViewController?
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Begin by selecting the button below or selecting 'Add' in the top right of the screen.", attributes: theme?.currentTheme.font.bodyText)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var addRecipeButton: StandardButton = {
        let button = StandardButton(title: "Add Recipe", theme: theme)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAddRecipe), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    convenience init(delegate: MainViewController,theme: ThemeManager) {
        self.init(frame: .zero)
        self.theme = theme
        self.delegate = delegate
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(addRecipeButton)
        addSubview(messageLabel)
        
        messageLabel.anchorView(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: UIScreen.main.bounds.height / 3, left: 20.0, bottom: 0.0, right: -20.0), size: .zero)
        addRecipeButton.anchorView(top: messageLabel.bottomAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: UIScreen.main.bounds.width / 3, height: 0.0))
    }
    
    @objc func handleAddRecipe() {
        delegate?.handleAddRecipe()
    }
}
