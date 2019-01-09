//
//  Extensions_Colour.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 15/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

extension UIFont {
    
    struct StandardTheme {
        struct Font {
            struct Style {
                static var Medium: String { return "Avenir-Medium" }
                static var Black: String { return "Avenir-Black" }
            }
            struct Size {
                static var SizeCell: CGFloat { return 16.0 }
                static var RecipeCellTotalTime: CGFloat { return 48.0 }
            }

        }
    }
}
    
extension UIColor {
    
    //MARK: - Light coloured theme with 3 prime colours
    struct StandardTheme {
        struct Font {
            static var TextColour: UIColor { return UIColor(red:0.11, green:0.11, blue:0.12, alpha:1.0) }
            static var TextColourDisabled: UIColor { return UIColor(red:0.71, green:0.71, blue:0.72, alpha:1.0) }

            static var RecipeLabelBackgroundColour : UIColor { return UIColor(red: 1, green: 1, blue: 1, alpha: 1.0) }
            
        }
        
        
        struct Recipe {
            static var RecipeCellBackground: UIColor { return UIColor(red: 1, green: 1, blue: 1, alpha: 1.0) }
            static var Background: UIColor { return UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0) }
            static var NameLabel: UIColor { return UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0) }
        }
    }
    
    //MARK: - Dark Theme
    
    //MARK: - 80s style theme
}
