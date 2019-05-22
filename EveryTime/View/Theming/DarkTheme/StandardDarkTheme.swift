//
//  StandardDarkTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct StandardDarkTheme: ThemeProtocol {
    
    var name: String = "Dark Mint"
    
    var description: String = "Dark gray with splashes of royal green"
    
    static var productIdentifier: String = "com.whizbang.Everytime.darkmint"
    
    static var resource: String = "darkmint"
    
    var tableView: TableViewThemeProtocol = TableViewStandardDarkTheme()
    
    var navigation: NavigationThemeProtocol = NavigationStandardDarkTheme()
    
    var font: FontThemeProtocol = FontStandardDarkTheme()
    
//    var attributedText: AttributedTextProtocol = AttributedTextDarkTheme()
    
    var button: ButtonThemeProtocol = ButtonStandardDarkTheme()
    
    var generalBackgroundColour: UIColor = UIColor.DarkMintColourPalette.lightBlack
    
    func applyTheme() {
        updateNavView()
        updateThemeView()
        updateSettingsView()
        updateButton()
        updateTableView() // including the main collection view
        UILabel.appearance(whenContainedInInstancesOf: [AboutView.self]).textColor = font.TextColour
        UILabel.appearance(whenContainedInInstancesOf: [UIPickerView.self]).textColor = font.TextColour
        
        
    }
    
    func updateNavView() {
        NavView.appearance().backgroundColor = navigation.backgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [NavView.self]).textColor = NavigationStandardDarkTheme.textColour
        UILabel.appearance().textColor = NavigationStandardDarkTheme.textColour
    }
    
    func updateThemeView() {
        UILabel.appearance(whenContainedInInstancesOf: [ThemeTableViewCell.self]).textColor = font.TextColour
    }
    
    func updateSettingsView() {
//        UILabel.appearance(whenContainedInInstancesOf: [SettingsViewCell.self]).textColor = font.TextColour
    }
    
    func updateTableView() {
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = font.TextColour

        UICollectionView.appearance().backgroundColor = tableView.backgroundColor
        UITableView.appearance().backgroundColor = tableView.backgroundColor
        UITableViewCell.appearance().backgroundColor = tableView.cellBackgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [RecipeViewCell.self]).textColor = font.TextColour
        UILabel.appearance(whenContainedInInstancesOf: [StepTableViewCell.self]).textColor = font.TextColour
        UIImageView.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).tintColor = .white
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
