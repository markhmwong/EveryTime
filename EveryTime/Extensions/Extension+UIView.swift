//
//  Extension+UIView.swift
//  EveryTime
//
//  Created by Mark Wong on 22/3/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

extension UIView {
    func anchorView(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, centerY: NSLayoutYAxisAnchor?, centerX: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: padding.right).isActive = true
        }
        
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        
        if (size.width != 0.0) {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if (size.height != 0.0) {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
    }
}
