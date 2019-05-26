//
//  ButtonStandardDeepMint.swift
//  EveryTime
//
//  Created by Mark Wong on 12/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
struct ButtonStandardDeepMintTheme: ButtonThemeProtocol {
    var text: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontStandardDeepMintTheme.FontStyle.Bold.rawValue, size: FontStandardDeepMintTheme.FontSize.Standard(.b3).value)!,
        NSAttributedString.Key.foregroundColor: NavigationStandardDeepMintTheme.textColour,
        NSAttributedString.Key.kern: FontStandardDeepMintTheme.FontKern.General.floatValue
    ]
    var backgroundColor: UIColor = UIColor.DeepMintColourPalette.green
    
    //for reset button and pause button
    var buttonSizeMultiplier: Double {
        if (UIDevice.current.iPad) {
            return 1.5
        } else {
            return 1.0
        }
    }
}
