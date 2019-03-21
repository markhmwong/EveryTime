//
//  Extensions.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 4/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

//https://stackoverflow.com/questions/47844460/how-have-hourminutesseconds-in-date-picker-swift?rq=1
extension AddStepViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case pickerColumn.hour.rawValue:
            return 25
        case pickerColumn.min.rawValue, pickerColumn.sec.rawValue:
            return 60
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width / 6
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case pickerColumn.hour.rawValue:
            return "\(row)"
        case pickerColumn.min.rawValue:
            return "\(row)"
        case pickerColumn.sec.rawValue:
            return "\(row)"
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case pickerColumn.hour.rawValue:
            hours = row
        case pickerColumn.min.rawValue:
            minutes = row
        case pickerColumn.sec.rawValue:
            seconds = row
        default:
            break;
        }
    }
}

//https://medium.com/@luisfmachado/uipickerview-fixed-labels-66f947ded0a8
extension UIPickerView {
    
    func setPickerLabels(labels: [Int:UILabel], containedView: UIView) { // [component number:label]
        
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
                
                self.addSubview(label)
            }
        }
    }
}

extension UIView {
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
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action),
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
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action),
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

extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhone4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneXR = "iPhone XR"
        case iPhoneX_iPhoneXS = "iPhone X,iPhoneXS"
        case iPhoneXSMax = "iPhoneXS Max"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhoneXR
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhoneX_iPhoneXS
        case 2688:
            return .iPhoneXSMax
        default:
            return .unknown
        }
    }
}
