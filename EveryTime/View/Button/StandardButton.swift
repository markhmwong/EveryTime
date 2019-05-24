//
//  Button.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 18/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import StoreKit

class StandardButton: UIButton {
    
    var theme: ThemeManager?
    
    var buyButtonHandler: ((_ product: SKProduct) -> Void)?
    
    var product: SKProduct?
    
    init(title: String, theme: ThemeManager?) {
        self.theme = theme
        super.init(frame: .zero)
        self.setupView(title)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(_ title: String) {
        translatesAutoresizingMaskIntoConstraints = false
        setAttributedTitle(NSAttributedString(string: title, attributes: theme?.currentTheme.button.text), for: .normal)
        backgroundColor = theme?.currentTheme.button.backgroundColor
        layer.cornerRadius = 5.0
        titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    }
    
    func updateButtonTitle(with title: String) {
        DispatchQueue.main.async {
            self.setAttributedTitle(NSAttributedString(string: title, attributes: self.theme?.currentTheme.button.text), for: .normal)
        }
    }
    
    func updateLabel(string: String) {
        setAttributedTitle(NSAttributedString(string: string, attributes: theme?.currentTheme.button.text), for: .normal)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: [.allowUserInteraction], animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (state) in
            ()
        }
        super.touchesBegan(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: [.allowUserInteraction], animations: {
            self.transform = .identity
        }) { (state) in
            ()
        }
        super.touchesEnded(touches, with: event)
    }
}
