//
//  FontStandardDarkTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct FontStandardDarkTheme: FontThemeProtocol {
    var Regular: String { return FontStyle.Regular.rawValue }
    
    var Bold: String { return FontStyle.Bold.rawValue }
    
//    static var white: UIColor { return UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0) }
//    static var TextColor: UIColor { return UIColor(red:0.01, green:0.09, blue:0.14, alpha:1.0) }
    
    enum FontStyle: String {
        case Regular = "Avenir-Medium"
        case Bold = "Avenir-Black"
    }
    
    enum FontKern: CGFloat {
        case General = 0.3
    }
    
    enum StandardSizes: CGFloat {
        //title sizes
        case h0 = 50.0
        case h1 = 40.0
        case h2 = 30.0
        
        //body sizes
        case b0 = 26.0
        case b1 = 20.0
        case b2 = 16.0
        case b3 = 14.0
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
