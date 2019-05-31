//
//  UpgradeHeaderView.swift
//  EveryTime
//
//  Created by Mark Wong on 30/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class UpgradeHeaderView: UICollectionReusableView {
    
    var theme: ThemeManager?
    
    lazy var proDetails: UILabel = {
       let label = UILabel()
        label.attributedText = NSAttributedString(string: "Three timers not enough?\nUnlock unlimited timers with Pro", attributes: theme?.currentTheme.font.bodyText)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var upgradeButton: StandardButton = {
       let upgradeButton = StandardButton(title: "Upgrade To Pro", theme: theme)
        upgradeButton.addTarget(self, action: #selector(handleUpgrade), for: .touchUpInside)
        return upgradeButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    func setupView() {
        addSubview(proDetails)
        addSubview(upgradeButton)
        proDetails.anchorView(top: nil, bottom: centerYAnchor, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: .zero, size: .zero)
        upgradeButton.anchorView(top: proDetails.bottomAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: bounds.width / 3, height: bounds.height / 4))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleUpgrade() {
        
    }
}
