//
//  ThemeProtocol.swift
//  EveryTime
//
//  Created by Mark Wong on 7/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

protocol ThemeProtocol {
    
    var navigation: NavigationThemeProtocol { get set }
    
    var font: FontThemeProtocol { get }
    
    var attributedText: AttributedTextProtocol { get }
    
    var tableView: TableViewThemeProtocol { get }
    
    func applyTheme()
}
