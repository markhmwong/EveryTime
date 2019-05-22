//
//  ThemeProtocol.swift
//  EveryTime
//
//  Created by Mark Wong on 7/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

protocol ThemeProtocol {
    
    var name: String { get }
    
    var description: String { get }
    
    static var productIdentifier: String { get }
    
    static var resource: String { get }
    
    var navigation: NavigationThemeProtocol { get set }
    
    var font: FontThemeProtocol { get }
    
//    var attributedText: AttributedTextProtocol { get }
    
    var tableView: TableViewThemeProtocol { get }
    
    var button: ButtonThemeProtocol { get }

    var generalBackgroundColour: UIColor { get }
    
    // MARK: - These are specifically for the Theme View Controller cells to show a preview of the theme. We just are presenting the main colours of the theme.
//    var themeColourBackground: UIColor { get }
    
    func resourceName() -> String
    
    func productIdentifier() -> String
    
    func applyTheme()
}
