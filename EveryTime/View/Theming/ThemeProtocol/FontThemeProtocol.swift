//
//  FontThemeProtocol.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

protocol FontThemeProtocol {
    var Regular: String { get }
    var Bold: String { get }
    var TextColour: UIColor { get }
    
    // MARK: - Large Display
    var recipeName: [NSAttributedString.Key : Any] { get }
    var stepName: [NSAttributedString.Key : Any] { get }
    var stepTime: [NSAttributedString.Key : Any] { get }

}
