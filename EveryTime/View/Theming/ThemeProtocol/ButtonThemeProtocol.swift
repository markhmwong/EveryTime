//
//  ButtonThemeProtocol.swift
//  EveryTime
//
//  Created by Mark Wong on 10/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit.UIColor

protocol ButtonThemeProtocol {
    var text: [NSAttributedString.Key : Any] { get }
    var backgroundColor: UIColor { get }
}
