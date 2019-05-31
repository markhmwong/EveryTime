//
//  ButtonStandardLightTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 10/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class ButtonStandardLightTheme: ButtonThemeProtocol {
    var text: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Bold.rawValue, size: FontStandardLightTheme.FontSize.Standard(.b3).value)!,
        NSAttributedString.Key.foregroundColor: NavigationStandardLightTheme.textColour,
        NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue,
    ]
    var backgroundColor: UIColor = UIColor.LightMintColourPalette.teal
    
    //for reset button and pause button
    var buttonSizeMultiplier: Double {
        if (UIDevice.current.iPad) {
            return 1.5
        } else {
            return 1.0
        }
    }
}
