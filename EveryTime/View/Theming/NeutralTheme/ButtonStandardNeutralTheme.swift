//
//  ButonStandardNeutralTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 20/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct ButtonStandardNeutralTheme: ButtonThemeProtocol {
    var text: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontNeutralTheme.FontStyle.Bold.rawValue, size: FontNeutralTheme.FontSize.Standard(.b3).value)!,
        NSAttributedString.Key.foregroundColor: NavigationNeutralTheme.textColour,
        NSAttributedString.Key.kern: FontNeutralTheme.FontKern.General.floatValue
    ]
    var backgroundColor: UIColor = UIColor.NeutralColourPalette.gray
    
    //for reset button and pause button
    var buttonSizeMultiplier: Double {
        if (UIDevice.current.iPad) {
            return 1.5
        } else {
            return 1.0
        }
    }
}
