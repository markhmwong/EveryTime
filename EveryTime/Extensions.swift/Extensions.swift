//
//  Extensions.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 4/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

//https://medium.com/@luisfmachado/uipickerview-fixed-labels-66f947ded0a8
extension UIPickerView {
    
    func setPickerLabels(labels: [Int:UILabel], containedView: UIView, theme: ThemeManager) { // [component number:label]
        
        let fontSize:CGFloat = 20
        let labelWidth:CGFloat = containedView.bounds.width / CGFloat(self.numberOfComponents)
        let x:CGFloat = self.frame.origin.x
        let y:CGFloat = (self.frame.size.height / 2) - (fontSize / 2)
        
        for i in 0...self.numberOfComponents {

            if let label = labels[i] {
                
                if self.subviews.contains(label) {
                    label.removeFromSuperview()
                }
                
                label.frame = CGRect(x: x + labelWidth * CGFloat(i), y: y, width: labelWidth, height: fontSize)
                label.font = UIFont.boldSystemFont(ofSize: fontSize)
                label.backgroundColor = .clear
                label.textAlignment = NSTextAlignment.center
                label.textColor = theme.currentTheme.font.TextColour
                self.addSubview(label)
            }
        }
    }
}


extension TimeInterval {
    //returns a tuple containing the seconds minutes and hours. Basically a conversion from seconds.
    func secondsToHoursMinutesSeconds() -> (Int, Int, Int) {
        let seconds = Int(self)
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}

extension Int {
    func prefixZeroToInteger() -> String {
        if(self < 10) {
            return "0\(self)"
        } else {
            return "\(self)"
        }
    }
    
}

extension UITextField {
    func addAddDoneButonToolbar(onDone: (target: Any, action: Selector)? = nil, onAdd: (target: Any, action: Selector)? = nil, onEdit: (target: Any, action: Selector)? = nil, onDismiss: (target: Any, action: Selector)? = nil) {
        let onDone = onDone ?? (target: self, action: #selector(handleDoneButton))
        let onAdd = onAdd ?? (target: self, action: #selector(handleDoneButton))
        let onDismiss = onDismiss ?? (target: self, action: #selector(handleDismissButton))

        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Dismiss", style: .done, target: onDone.target, action: onDismiss.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Finish", style: .done, target: onDone.target, action: onDone.action),
            UIBarButtonItem(title: "Add", style: .done, target: onAdd.target, action: onAdd.action),
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    func addNextButtonToolbar(onNext: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil, onDone: (target: Any, action: Selector)? = nil, onDismiss: (target: Any, action: Selector)? = nil) {
        let onNext = onNext ?? (target: self, action: #selector(handleContinueButton))
        let onDone = onDone ?? (target: self, action: #selector(handleDoneButton))
        let onDismiss = onDismiss ?? (target: self, action: #selector(handleDismissButton))

        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Dismiss", style: .done, target: onDone.target, action: onDismiss.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Finish", style: .done, target: onDone.target, action: onDone.action),
            UIBarButtonItem(title: "Next", style: .done, target: onNext.target, action: onNext.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func handleDoneButton() { self.resignFirstResponder() }
    @objc func handleContinueButton() { self.resignFirstResponder() }
    @objc func handleAddButton() { self.resignFirstResponder() }
    @objc func handleEditButton() { self.resignFirstResponder() }
    @objc func handleDismissButton() { self.resignFirstResponder() }

}

extension String {
    
    var integerValue:Int? {
        return NumberFormatter().number(from:self)?.intValue
    }
}

extension Bundle {
    static func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        if let version : String = dictionary["CFBundleName"] as? String {
            return version
        } else {
            return ""
        }
    }
}


