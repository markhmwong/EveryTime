//
//  AddstepViewController+UIPickerView.swift
//  EveryTime
//
//  Created by Mark Wong on 15/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

//https://stackoverflow.com/questions/47844460/how-have-hourminutesseconds-in-date-picker-swift?rq=1

extension AddStepViewControllerBase: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case PickerColumn.hour.rawValue:
            return 24
        case PickerColumn.min.rawValue, PickerColumn.sec.rawValue:
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
        case PickerColumn.hour.rawValue:
            return "\(row)"
        case PickerColumn.min.rawValue:
            return "\(row)"
        case PickerColumn.sec.rawValue:
            return "\(row)"
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case PickerColumn.hour.rawValue:
            hours = row
        case PickerColumn.min.rawValue:
            minutes = row
        case PickerColumn.sec.rawValue:
            seconds = row
        default:
            break;
        }
    }
}
