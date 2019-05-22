//
//  OrangeTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 19/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct OrangeTheme: ThemeProtocol {
    
    static var productIdentifier: String = "com.whizbang.Everytime.orangetheme"
    
    static var resource: String = "orangetheme"
    
    var name: String = "Orange"
    
    var description: String = "Orange like your household cat"
    
    var navigation: NavigationThemeProtocol = NavigationStandardOrangeTheme()
    
    var font: FontThemeProtocol = FontStandardOrangeTheme()
    
    var tableView: TableViewThemeProtocol = TableViewStandardOrangeTheme()
    
    var button: ButtonThemeProtocol = ButtonStandardOrangeTheme()
    
    var generalBackgroundColour: UIColor = UIColor.OrangeColourPalette.white
    
    func applyTheme() {
        updateNavView()
        updateSettingsView()
        updateTableView()
        UILabel.appearance(whenContainedInInstancesOf: [AboutView.self]).textColor = font.TextColour
    }
    
    func updateNavView() {
        NavView.appearance().backgroundColor = navigation.backgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [NavView.self]).textColor = NavigationStandardOrangeTheme.textColour
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
