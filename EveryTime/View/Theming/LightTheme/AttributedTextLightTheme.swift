//
//  AttributedText.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct AttributedTextLightTheme: AttributedTextProtocol {
    //Navigation
    var navigationItem: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Regular.rawValue, size: FontStandardLightTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue]
    var navigationTitle: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Regular.rawValue, size: FontStandardLightTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue]
    
    // MARK: - Text
    var bodyText: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Bold.rawValue, size: FontStandardLightTheme.FontSize.Standard(.b3).value)!, NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue]
}
