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
    struct View {
        static var CornerRadius: CGFloat { return 0.0 }
        
        struct Nav {
            static var Height: CGFloat { return 0.08 }
        }
    }
    struct Font {
        fileprivate typealias tf = Theme.Font
        
        struct Error {
            static let Text: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Medium, size: tf.Size.Error)!, NSAttributedString.Key.foregroundColor: tf.Color.ErrorColor, NSAttributedString.Key.kern: tf.Kern.TitleKernValue]
        }
        
        private struct Style {
            static var Medium: String { return "Avenir-Medium" }
            static var Bold: String { return "Avenir-Black" }
        }
        
        private struct Size {
            static var SizeCell: CGFloat { return 14.0 }
            static var MainViewCellName: CGFloat { return 12.0 }
            static var MainViewCellTime: CGFloat { return 32.0 }
            static var MainViewStepName: CGFloat { return 12.0 }
            static var StepTitle: CGFloat { return 20.0 }
            static var StepTime: CGFloat { return 40.0 }
            static var StepCellTitle: CGFloat { return 11.0 }
            static var StepCellTime: CGFloat { return 18.0 }
            static var AddStepPlaceholder: CGFloat { return 40.0 }
            static var PageTitle: CGFloat { return 12.0 }
            static var TextField: CGFloat { return 20.0 }
            static var NavItem: CGFloat { return 14.0 }
            static var Caret: CGFloat { return 30.0 }
            static var StandardButton: CGFloat { return 12.0 }
            static var Header: CGFloat { return 20.0 }
            static var HeaderContent: CGFloat { return 16.0 }
            static var HeaderContentTitle: CGFloat { return 12.0 }
            static var HeaderContentTime: CGFloat { return 20.0 }

            static var About: CGFloat { return 14.0 }
            static var Error: CGFloat { return 12.0 }
            static var CompleteDot: CGFloat { return 30.0 }
        }
        
        //spacing between characters
        private struct Kern {
            static var TitleKernValue: NSNumber { return 2.0 }
            static var TimerKernValue: NSNumber { return 2.0 }
            static var GeneralKernValue: NSNumber { return 0.5 }
        }
        
        struct Color {
            static var ErrorColor: UIColor { return UIColor(red:0.73, green:0.24, blue:0.13, alpha:1.0) }
            static var TextColour: UIColor { return UIColor(red:0.01, green:0.09, blue:0.14, alpha:1.0) }
            
            static var TextColourDisabled: UIColor { return UIColor(red:0.9, green:0.9, blue:0.9, alpha:1.0) }
            static var RecipeLabelBackgroundColour : UIColor { return UIColor(red: 1, green: 1, blue: 1, alpha: 1.0) }
            static var RecipeCellStepTitle: UIColor { return UIColor(red:0.01, green:0.09, blue:0.14, alpha:1.0) }

            static var StepCellCompleteIndicator: UIColor { return UIColor(red:0.29, green:1.0, blue:0.50, alpha:1.0) }
            static var StepCellIncompleteIndicator: UIColor { return UIColor(red:1.0, green:0.77, blue:0.77, alpha:1.0) }
            
            static var StandardButtonColor: UIColor { return UIColor(red:0.56, green:0.84, blue:0.79, alpha:1.0) }
        }
        
        // At the Recipe list view (Main View COntroller)
        struct Recipe {
            private static let TextFieldParagraphStyle: NSMutableParagraphStyle = {
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                return style
            }()
            static let HeaderTableView: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Bold, size: tf.Size.Header)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.TitleKernValue]
            static let HeaderTableViewContent: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Medium, size: tf.Size.HeaderContent)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.TitleKernValue]
            static let HeaderTableViewContentSubTitle: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Bold, size: tf.Size.HeaderContentTitle)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.TitleKernValue]
            static let HeaderTableViewContentTitle: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Medium, size: tf.Size.HeaderContentTitle)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.TitleKernValue]
            static let HeaderTableViewContentTime: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Bold, size: tf.Size.HeaderContentTime)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.TitleKernValue]

            
            static let CaretAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Medium, size: tf.Size.Caret)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.TitleKernValue, NSAttributedString.Key.paragraphStyle: TextFieldParagraphStyle]
            static let TitleAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Medium, size: tf.Size.PageTitle)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.TitleKernValue]
            static let TextFieldAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Medium, size: tf.Size.TextField)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.TitleKernValue, NSAttributedString.Key.paragraphStyle: TextFieldParagraphStyle]
            static let TimeAttributeInactive: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Bold, size: tf.Size.MainViewCellTime)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColourDisabled, NSAttributedString.Key.kern: tf.Kern.TimerKernValue]
            static let TimeAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Bold, size: tf.Size.MainViewCellTime)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.TimerKernValue]
            static let NameAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Medium, size: tf.Size.MainViewCellName)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.GeneralKernValue]
            static let PauseAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Bold, size: tf.Size.SizeCell)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.GeneralKernValue]
            static let StepSubTitle: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Bold, size: tf.Size.MainViewStepName)!, NSAttributedString.Key.foregroundColor: tf.Color.RecipeCellStepTitle, NSAttributedString.Key.kern: tf.Kern.GeneralKernValue]
        }
        
        struct Step {
            static let NameAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Medium, size: tf.Size.StepTitle)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.GeneralKernValue]
            static let TimeAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Medium, size: tf.Size.StepTime)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.TitleKernValue]
            static let AddStep: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Medium, size: tf.Size.AddStepPlaceholder)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.TitleKernValue]
            static let CellNameAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Bold, size: tf.Size.StepCellTitle)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.GeneralKernValue]
            static let CellTimeAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Medium, size: tf.Size.StepCellTime)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.TimerKernValue]
            static let CellIndicatorComplete: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Medium, size: tf.Size.CompleteDot)!, NSAttributedString.Key.foregroundColor: tf.Color.StepCellCompleteIndicator, NSAttributedString.Key.kern: tf.Kern.GeneralKernValue]
            static let CellIndicatorIncomplete: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Medium, size: tf.Size.CompleteDot)!, NSAttributedString.Key.foregroundColor: tf.Color.StepCellIncompleteIndicator, NSAttributedString.Key.kern: tf.Kern.GeneralKernValue]
        }
        
        struct Nav {
            static let StandardButton: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Bold, size: tf.Size.StandardButton)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.GeneralKernValue]
            static let Item: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Medium, size: tf.Size.NavItem)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.GeneralKernValue]
            static let RecipeTitle: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Bold, size: tf.Size.NavItem)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.GeneralKernValue]
            static let AppName: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Bold, size: tf.Size.NavItem)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.GeneralKernValue]
            static let Height: CGFloat = 0.08
        }
        
        struct About {
            static let Text: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: tf.Style.Medium, size: tf.Size.About)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.GeneralKernValue]
        }
    }
    
    struct Background {
        fileprivate typealias tb = Theme.Background
        struct Color {
            static var Clear: UIColor { return UIColor(red:1.0, green:1.0, blue:1.0, alpha:0.0) }
            static var GeneralBackgroundColor: UIColor { return UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0) }
            static var CellBackgroundColor: UIColor { return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) }
            static var NavBackgroundColor: UIColor { return UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0) }
            static var NavBottomBorderColor: UIColor { return UIColor(red: 220.0 / 255.0, green: 220.0 / 255.0, blue: 220.0 / 255.0, alpha: 1.0) }
            static var CellButtonBackgroundColor: UIColor { return UIColor(red:0.01, green:0.09, blue:0.14, alpha:1.0) }
            static var MainViewTimerCellHighlight: UIColor { return UIColor(red:0.39, green:0.13, blue:0.38, alpha:0.85) }

        }
        struct Gradient {
            static var CellColorTop: CGColor { return UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.0).cgColor }
            static var CellColorBottom: CGColor { return UIColor(red: 180.0 / 255.0, green: 180.0 / 255.0, blue: 180.0 / 255.0, alpha: 0.3).cgColor }
            static var BackgroundTop: CGColor { return UIColor(red:0.40, green:0.70, blue:0.44, alpha:1.0).cgColor }
            static var BackgroundBottom: CGColor { return UIColor(red:0.30, green:0.64, blue:0.80, alpha:1.0).cgColor }
        }
    }
}
