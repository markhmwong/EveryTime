//
//  StandardDarkTheme.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct StandardDarkTheme: ThemeProtocol {
    var tableView: TableViewThemeProtocol = TableViewStandardDarkTheme()
    
    var navigation: NavigationThemeProtocol = NavigationStandardDarkTheme()
    
    var font: FontThemeProtocol = FontStandardDarkTheme()
    
    var attributedText: AttributedTextProtocol = AttributedTextDarkTheme()
    
    func applyTheme() {
        updateNavView()
        updateThemeView()
        updateSettingsView()
    }
    
    func updateNavView() {
        NavView.appearance().backgroundColor = navigation.backgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [NavView.self]).textColor = NavigationStandardDarkTheme.textColour
        UILabel.appearance().textColor = NavigationStandardDarkTheme.textColour
        
        UITableView.appearance().backgroundColor = tableView.backgroundColor
        UITableViewCell.appearance().backgroundColor = tableView.cellBackgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = font.TextColour
    }
    
    func updateThemeView() {
        UILabel.appearance(whenContainedInInstancesOf: [ThemeTableViewCell.self]).textColor = font.TextColour

    }
    
    func updateSettingsView() {
//        UILabel.appearance(whenContainedInInstancesOf: [SettingsViewCell.self]).textColor = font.TextColour
    }
}
