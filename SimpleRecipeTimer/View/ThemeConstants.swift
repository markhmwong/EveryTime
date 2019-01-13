//
//  ThemeConstants.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 14/1/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation
import UIKit

struct Theme {
    struct Font {
        typealias tf = Theme.Font
        
        struct Style {
            static var Medium: String { return "Avenir-Medium" }
            static var Bold: String { return "Avenir-Black" }
        }
        
        struct Size {
            static var SizeCell: CGFloat { return 14.0 }
            static var RecipeCellTime: CGFloat { return 20.0 }
        }
        
        struct Color {
            static var TextColour: UIColor { return UIColor(red:0.11, green:0.11, blue:0.12, alpha:1.0) }
            static var TextColourDisabled: UIColor { return UIColor(red:0.71, green:0.71, blue:0.72, alpha:1.0) }
            static var RecipeLabelBackgroundColour : UIColor { return UIColor(red: 1, green: 1, blue: 1, alpha: 1.0) }
            
        }
        
        // At the Recipe list view (Main View COntroller)
        struct Recipe {
            static let TimeAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Medium, size: tf.Size.RecipeCellTime)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: 1]
            static let NameAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Bold, size: tf.Size.SizeCell)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: 0.5]
            static let PauseAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Bold, size: tf.Size.SizeCell)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: 0.5]

        }
    }
}
