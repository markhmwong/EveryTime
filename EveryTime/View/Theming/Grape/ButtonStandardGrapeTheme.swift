//
//  ButtonStandardLightTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 10/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class ButtonStandardGrapeTheme: ButtonThemeProtocol {
    var text: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font: UIFont(name: FontStandardGrapeTheme.FontStyle.Bold.rawValue, size: FontStandardGrapeTheme.FontSize.Standard(.b3).value)!,
        NSAttributedString.Key.foregroundColor: NavigationStandardGrapeTheme.textColour,
        NSAttributedString.Key.kern: FontStandardGrapeTheme.FontKern.General.floatValue,
    ]
    var backgroundColor: UIColor = UIColor.GrapeColourPalette.purple
}
