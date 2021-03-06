//
//  ButtonStandardLightTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 10/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class ButtonStandardOrangeTheme: ButtonThemeProtocol {
    var text: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontStandardOrangeTheme.FontStyle.Bold.rawValue, size: FontStandardOrangeTheme.FontSize.Standard(.b3).value)!,
        NSAttributedString.Key.foregroundColor: NavigationStandardOrangeTheme.textColour,
        NSAttributedString.Key.kern: FontStandardOrangeTheme.FontKern.General.floatValue,
    ]
    var backgroundColor: UIColor = UIColor.OrangeColourPalette.orange
    
    //for reset button and pause button
    var buttonSizeMultiplier: Double {
        if (UIDevice.current.iPad) {
            return 1.5
        } else {
            return 1.0
        }
    }
}
