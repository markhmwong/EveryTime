//
//  LightTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct StandardLightTheme: ThemeProtocol {
    
    static var productIdentifier: String = "com.whizbang.Everytime.lightmint"
    
    static var resource: String = "lightmint"
    
    var name: String = "Light Mint"
    
    var description: String = "A little like mouthwash"
    
    var navigation: NavigationThemeProtocol = NavigationStandardLightTheme()
    
    var font: FontThemeProtocol = FontStandardLightTheme()
    
//    var attributedText: AttributedTextProtocol = AttributedTextLightTheme()
    
    var tableView: TableViewThemeProtocol = TableViewStandardLightTheme()
    
    var button: ButtonThemeProtocol = ButtonStandardLightTheme()
    
    var generalBackgroundColour: UIColor = UIColor.LightMintColourPalette.white

    func applyTheme() {
        updateNavView()
        updateSettingsView()
        updateTableView()
        UILabel.appearance(whenContainedInInstancesOf: [AboutView.self]).textColor = font.TextColour

    }
    
    func updateNavView() {
        NavView.appearance().backgroundColor = navigation.backgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [NavView.self]).textColor = NavigationStandardLightTheme.textColour
        UILabel.appearance().textColor = font.TextColour
    }
    
    func updateThemeView() {
        UILabel.appearance(whenContainedInInstancesOf: [ThemeTableViewCell.self]).textColor = font.TextColour
        
    }
    
    func updateSettingsView() {
        UILabel.appearance(whenContainedInInstancesOf: [SettingsViewCell.self]).textColor = font.TextColour
    }
    
    func updateTableView() {
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = font.TextColour
        UILabel.appearance(whenContainedInInstancesOf: [ThemeTableViewCell.self]).textColor = font.TextColour
        UITableView.appearance().backgroundColor = tableView.backgroundColor
        UITableViewCell.appearance().backgroundColor = tableView.cellBackgroundColor
        
        UICollectionView.appearance().backgroundColor = tableView.backgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [RecipeViewCell.self]).textColor = font.TextColour
    }
    
    func updateButton() {
        
    }
    
    func resourceName() -> String {
        return type(of: self).resource
    }
    
    func productIdentifier() -> String {
        return type(of: self).productIdentifier
    }
}
