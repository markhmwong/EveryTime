//
//  ThemeNavigationProtocol.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

protocol NavigationThemeProtocol {
    // MARK: - Background
    var backgroundColor: UIColor { get set }
    
    // MARK: - Text
    static var textColour: UIColor { get set }
    static var titleColour: UIColor { get set }
    
    // MARK: - Attributed Texts
    var navigationItem: [NSAttributedString.Key: Any] { get }
    var navigationTitle: [NSAttributedString.Key: Any] { get }
}
