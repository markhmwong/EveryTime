//
//  LightTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct NeutralTheme: ThemeProtocol {
    
    static var productIdentifier: String = "com.whizbang.Everytime.neutraltheme"
    
    static var resource: String = "neutraltheme"
    
    var name: String = "Neutral"
    
    var description: String = "Like a newspaper"
    
    var navigation: NavigationThemeProtocol = NavigationNeutralTheme()
    
    var font: FontThemeProtocol = FontNeutralTheme()
    
    var tableView: TableViewThemeProtocol = TableViewNeutralTheme()
    
    var button: ButtonThemeProtocol = ButtonStandardNeutralTheme()
    
    var generalBackgroundColour: UIColor = UIColor.NeutralColourPalette.offWhite

    func applyTheme() {
        updateNavView()
        updateSettingsView()
        updateTableView()
        UILabel.appearance(whenContainedInInstancesOf: [AboutView.self]).textColor = font.TextColour

    }
    
    func updateNavView() {
        NavView.appearance().backgroundColor = navigation.backgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [NavView.self]).textColor = NavigationNeutralTheme.textColour
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
