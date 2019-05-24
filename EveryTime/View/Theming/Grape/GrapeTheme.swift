//
//  LightTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct GrapeTheme: ThemeProtocol {
    
    static var productIdentifier: String = "com.whizbang.Everytime.grapetheme"
    
    static var resource: String = "grapetheme"
    
    var name: String = "Grape"
    
    var description: String = "Fruity"
    
    var navigation: NavigationThemeProtocol = NavigationStandardGrapeTheme()
    
    var font: FontThemeProtocol = FontStandardGrapeTheme()
        
    var tableView: TableViewThemeProtocol = TableViewStandardGrapeTheme()
    
    var button: ButtonThemeProtocol = ButtonStandardGrapeTheme()
    
    var generalBackgroundColour: UIColor = UIColor.GrapeColourPalette.pastelGreen

    func applyTheme() {
        updateNavView()
        updateSettingsView()
        updateTableView()
        UILabel.appearance(whenContainedInInstancesOf: [AboutView.self]).textColor = font.TextColour

    }
    
    func updateNavView() {
        NavView.appearance().backgroundColor = navigation.backgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [NavView.self]).textColor = NavigationStandardGrapeTheme.textColour
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
