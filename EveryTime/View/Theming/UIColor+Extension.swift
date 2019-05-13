//
//  UIColor+Extension.swift
//  EveryTime
//
//  Created by Mark Wong on 7/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit.UIColor

extension UIColor {
    // MARK: - Dark Theme
    struct DarkMintColourPalette {
        static var black: UIColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0)
        static var lightBlack: UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        static var white: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        static var whiteFaded: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)

        static var teal: UIColor = UIColor(red:0.52, green:0.83, blue:0.73, alpha:1.0)
        static var green: UIColor = UIColor(red:0.03, green:0.31, blue:0.27, alpha:1.0)
        static var greenFaded: UIColor = UIColor(red:0.03, green:0.31, blue:0.27, alpha:0.7)

        static var darkGray: UIColor = UIColor(red: 100.0 / 255.0, green: 100.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
    }
    
    struct LightMintColourPalette {
        static var white: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        static var lightGray: UIColor = UIColor(red: 245.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        static var gray: UIColor = UIColor(red: 200.0 / 255.0, green: 200.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)

        static var darkTeal: UIColor = UIColor(red:0.01, green:0.09, blue:0.14, alpha:1.0)
        static var darkTealFaded: UIColor = UIColor(red:0.01, green:0.09, blue:0.14, alpha:0.8)

        static var teal: UIColor = UIColor(red:0.52, green:0.83, blue:0.73, alpha:1.0)
        static var lightTeal: UIColor = UIColor(red:0.52, green:0.83, blue:0.73, alpha:0.4)
    }
    
    struct DeepMintColourPalette {
        static var black: UIColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.0)
        static var lightBlack: UIColor = UIColor(red: 0.03, green: 0.03, blue: 0.03, alpha: 1.0)
        
        static var white: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        static var whiteFaded: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        
        static var teal: UIColor = UIColor(red:0.08, green:0.61, blue:0.64, alpha:1.0)
        static var green: UIColor = UIColor(red:0.08, green:0.61, blue:0.64, alpha:1.0)
        static var greenFaded: UIColor = UIColor(red:0.08, green:0.61, blue:0.64, alpha:0.7)
        
        static var darkGray: UIColor = UIColor(red: 100.0 / 255.0, green: 100.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
    }
}
