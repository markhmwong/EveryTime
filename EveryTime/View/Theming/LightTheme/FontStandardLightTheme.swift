//
//  FontStandardLightTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct FontStandardLightTheme: FontThemeProtocol {
    var Regular: String { return FontStyle.Regular.rawValue }
    
    var Bold: String { return FontStyle.Bold.rawValue }
    
    var TextColour: UIColor { return UIColor.LightMintColourPalette.darkTeal }
    
    var recipeName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Regular.rawValue, size: FontStandardLightTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardLightTheme.TextColor, NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue]
    
    var stepName: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Regular.rawValue, size: FontStandardLightTheme.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardLightTheme.TextColor, NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue]
    
    var stepTime: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: FontStandardLightTheme.FontStyle.Bold.rawValue, size: FontStandardLightTheme.FontSize.Standard(.h0).value)!, NSAttributedString.Key.foregroundColor: TableViewStandardLightTheme.TextColor, NSAttributedString.Key.kern: FontStandardLightTheme.FontKern.General.floatValue]
    
    enum FontStyle: String {
        case Regular = "Avenir-Medium"
        case Bold = "Avenir-Black"
    }
    
    enum FontKern: Int {
        case General
        
        var floatValue: Float {
            switch self {
                case .General: return 0.5
            }
        }
    }
    
    enum StandardSizes: CGFloat {
        //title sizes
        case h0 = 59.0
        case h1 = 40.0
        case h2 = 30.0
        case h3 = 28.0
        case h4 = 22.0
        //body sizes
        case b0 = 20.0
        case b1 = 16.0
        case b2 = 14.0
        case b3 = 12.0
    }
    
    enum FontSize {
        case Standard(StandardSizes)
        case Custom(CGFloat)
        
        var value: CGFloat {
            switch self {
            case .Standard(let size):
                switch UIDevice.current.screenType.rawValue {
                case UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue:
                    return size.rawValue * 0.8
                default:
                    return size.rawValue
                }
            case .Custom(let customSize):
                return customSize
            }
        }
    }
}
