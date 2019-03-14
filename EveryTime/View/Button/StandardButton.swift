//
//  Button.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 18/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class StandardButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        self.setupView(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(_ title: String) {
        setAttributedTitle(NSAttributedString(string: title, attributes: Theme.Font.Nav.StandardButton), for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Theme.Font.Color.StandardButtonColor
        layer.cornerRadius = 5.0
        titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    }
}