//
//  LightTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct StandardLightTheme: ThemeProtocol {
    
    var navigation: NavigationThemeProtocol = NavigationStandardLightTheme()
    
    var font: FontThemeProtocol = FontStandardLightTheme()
    
    var attributedText: AttributedTextProtocol = AttributedTextLightTheme()
    
    var tableView: TableViewThemeProtocol = TableViewStandardLightTheme()
    
    func applyTheme() {
        updateNavView()
        
        updateSettingsView()
    }
    
    func updateNavView() {
        NavView.appearance().backgroundColor = navigation.backgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [NavView.self]).textColor = NavigationStandardLightTheme.textColour
        UILabel.appearance().textColor = font.TextColour
        
        UITableView.appearance().backgroundColor = tableView.backgroundColor
        UITableViewCell.appearance().backgroundColor = tableView.cellBackgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = font.TextColour
        UILabel.appearance(whenContainedInInstancesOf: [ThemeTableViewCell.self]).textColor = font.TextColour

    }
    
    func updateThemeView() {
        UILabel.appearance(whenContainedInInstancesOf: [ThemeTableViewCell.self]).textColor = font.TextColour
        
    }
    
    func updateSettingsView() {
        UILabel.appearance(whenContainedInInstancesOf: [SettingsViewCell.self]).textColor = font.TextColour
    }
}

//[NSAttributedString.Key.font: UIFont(name: tf.Style.Medium, size: tf.Size.About)!, NSAttributedString.Key.foregroundColor: tf.Color.TextColour, NSAttributedString.Key.kern: tf.Kern.GeneralKernValue]





/// To be determined for fonts
/// https://stackoverflow.com/questions/8707082/set-a-default-font-for-whole-ios-app/40484460#40484460
struct AppFontName {
    static let regular = "AmericanTypewriter"
    static let bold = "Avenir-Black"
    static let italic = ""
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
    
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.regular, size: size)!
    }
    
    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.bold, size: size)!
    }
    
    @objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.italic, size: size)!
    }
    
    @objc convenience init(myCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
                self.init(myCoder: aDecoder)
                return
        }
        var fontName = ""
        switch fontAttribute {
        case "CTFontRegularUsage":
            fontName = AppFontName.regular
        case "CTFontEmphasizedUsage", "CTFontBoldUsage":
            fontName = AppFontName.bold
        case "CTFontObliqueUsage":
            fontName = AppFontName.italic
        default:
            fontName = AppFontName.regular
        }
        self.init(name: fontName, size: fontDescriptor.pointSize)!
    }
    
    class func overrideInitialize() {
        guard self == UIFont.self else { return }
        
        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
            let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }
        
        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }
        
        if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
            let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:))) {
            method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
        }
        
        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))), // Trick to get over the lack of UIFont.init(coder:))
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
}
