//
//  ButtonStandardLightTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 10/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class ButtonStandardWhiteTheme: ButtonThemeProtocol {
    var text: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontStandardWhiteTheme.FontStyle.Bold.rawValue, size: FontStandardWhiteTheme.FontSize.Standard(.b3).value)!,
        NSAttributedString.Key.foregroundColor: NavigationStandardWhiteTheme.textColour,
        NSAttributedString.Key.kern: FontStandardWhiteTheme.FontKern.General.floatValue,
    ]
    var backgroundColor: UIColor = UIColor.WhiteColourPalette.white
    
    //for reset button and pause button
    var buttonSizeMultiplier: Double {
        if (UIDevice.current.iPad) {
            return 1.5
        } else {
            return 1.0
        }
    }
}
