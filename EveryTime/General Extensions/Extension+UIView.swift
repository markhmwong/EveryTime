//
//  Extension+UIView.swift
//  EveryTime
//
//  Created by Mark Wong on 22/3/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

extension UIView {
    func fillSuperView() {
        
        guard let s = superview else {
            return
        }
        
        topAnchor.constraint(equalTo: s.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: s.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: s.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: s.trailingAnchor).isActive = true
    }
    
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
    
    //https://stackoverflow.com/a/51359322/507170
    var textFieldsInView: [UITextField] {
        return subviews
            .filter ({ !($0 is UITextField) })
            .reduce (( subviews.compactMap { $0 as? UITextField }), { summ, current in
                return summ + current.textFieldsInView
            })
    }
    var selectedTextField: UITextField? {
        return textFieldsInView.filter { $0.isFirstResponder }.first
    }
    
    //https://stackoverflow.com/questions/7666863/uiview-bottom-border
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorder(color: UIColor = UIColor.red, margins: CGFloat = 0, borderLineSize: CGFloat = 1) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .height,
                                                multiplier: 1, constant: borderLineSize))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .leading,
                                              multiplier: 1, constant: margins))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .trailing,
                                              multiplier: 1, constant: margins))
    }
    

}
