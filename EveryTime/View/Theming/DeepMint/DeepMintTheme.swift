//
//  DeepMint.swift
//  EveryTime
//
//  Created by Mark Wong on 12/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct DeepMintTheme: ThemeProtocol {
    
    var name: String = "Deep Mint"
    
    var description: String = "Deeper than Jame Cameron's expedition"
    
    static var productIdentifier: String = "com.whizbang.Everytime.deepminttheme"
    
    static var resource: String = "deepminttheme"
    
    var tableView: TableViewThemeProtocol = TableViewStandardDeepMintTheme()
    
    var navigation: NavigationThemeProtocol = NavigationStandardDeepMintTheme()
    
    var font: FontThemeProtocol = FontStandardDeepMintTheme()
    
    var button: ButtonThemeProtocol = ButtonStandardDeepMintTheme()
    
    var generalBackgroundColour: UIColor = UIColor.DeepMintColourPalette.lightBlack

    
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
        UILabel.appearance(whenContainedInInstancesOf: [NavView.self]).textColor = NavigationStandardDeepMintTheme.textColour
        UILabel.appearance().textColor = NavigationStandardDeepMintTheme.textColour
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
        UILabel.appearance(whenContainedInInstancesOf: [ThemeTableViewCell.self]).textColor = font.TextColour
    }
    
    func updateButton() {
        
    }
    
    func resourceName() -> String {
        return type(of: self).resource
    }
    
    func productIdentifier() -> String {
        return type(of: self).productIdentifier
    }
    
    func themeDescription() -> String {
        return description
    }
}
