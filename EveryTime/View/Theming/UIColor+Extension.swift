//
//  UIColor+Extension.swift
//  EveryTime
//
//  Created by Mark Wong on 7/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit.UIColor

extension UIColor {
    struct GrapeColourPalette {
        static var purple: UIColor = UIColor(red:0.55, green:0.58, blue:0.84, alpha:1.0)
        static var pastelGreen: UIColor = UIColor(red:0.73, green:0.89, blue:0.92, alpha:1.0)
        static var white: UIColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
        static var blackFaded: UIColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.0)
        static var darkPurple: UIColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
        
    }
    
    struct OrangeColourPalette {
        static var white: UIColor = UIColor(red:0.99, green:0.97, blue:0.92, alpha:1.0)
        static var orange: UIColor = UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0)
        static var yellow: UIColor = UIColor(red:0.91, green:0.76, blue:0.23, alpha:1.0)
        static var orangeFaded: UIColor = UIColor(red:0.91, green:0.84, blue:0.76, alpha:1.0)
        static var darkOrange: UIColor = UIColor(red:0.25, green:0.14, blue:0.06, alpha:1.0)
    }
    
    struct WhiteColourPalette {
        static var white: UIColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
        static var lightGray: UIColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
        static var gray: UIColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0)
        static var blackFaded: UIColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.0)
        static var darkPurple: UIColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
    }
    
    struct LightMintColourPalette {
        static var white: UIColor = UIColor(red:0.95, green:0.99, blue:0.98, alpha:1.0)
        static var lightGray: UIColor = UIColor(red:0.90, green:0.95, blue:0.94, alpha:1.0)
        static var gray: UIColor = UIColor(red: 200.0 / 255.0, green: 200.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
        
        static var darkTeal: UIColor = UIColor(red:0.01, green:0.09, blue:0.14, alpha:1.0)
        static var darkTealFaded: UIColor = UIColor(red:0.01, green:0.09, blue:0.14, alpha:0.8)
        
        static var teal: UIColor = UIColor(red:0.43, green:0.93, blue:0.82, alpha:1.0)
        static var lightTeal: UIColor = UIColor(red:0.47, green:0.70, blue:0.66, alpha:1.0)
    }
    
    // MARK: - Dark Theme
    struct DarkMintColourPalette {
        static var black: UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        static var lightBlack: UIColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        static var white: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        static var whiteFaded: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        static var teal: UIColor = UIColor(red:0.52, green:0.83, blue:0.73, alpha:1.0)
        static var green: UIColor = UIColor(red:0.02, green:0.21, blue:0.16, alpha:1.0)
        static var greenFaded: UIColor = UIColor(red:0.18, green:0.25, blue:0.24, alpha:1.0)
        static var darkGray: UIColor = UIColor(red: 100.0 / 255.0, green: 100.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
    }

    struct DeepMintColourPalette {
        static var black: UIColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.0)
        static var lightBlack: UIColor = UIColor(red: 0.03, green: 0.03, blue: 0.03, alpha: 1.0)
        
        static var white: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        static var whiteFaded: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        
        static var teal: UIColor = UIColor(red:0.08, green:0.61, blue:0.64, alpha:1.0)
        static var green: UIColor = UIColor(red:0.08, green:0.61, blue:0.64, alpha:1.0)
        static var greenFaded: UIColor = UIColor(red:0.08, green:0.61, blue:0.64, alpha:0.4)
        
        static var darkGray: UIColor = UIColor(red: 100.0 / 255.0, green: 100.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
    }
    
    struct NeutralColourPalette {
        static var newspaperBlack: UIColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.0)
        static var lightBlack: UIColor = UIColor(red: 0.03, green: 0.03, blue: 0.03, alpha: 1.0)
        static var offWhite: UIColor = UIColor(red:0.83, green:0.83, blue:0.83, alpha:1.0)

        static var gray: UIColor = UIColor(red:0.56, green:0.56, blue:0.56, alpha:1.0)
        static var grayFaded: UIColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0)
        
        static var darkGray: UIColor = UIColor(red: 100.0 / 255.0, green: 100.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
    }
}
