//
//  TableViewThemeProtocol.swift
//  EveryTime
//
//  Created by Mark Wong on 7/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

protocol TableViewThemeProtocol {
    var backgroundColor: UIColor { get set }
    var cellBackgroundColor: UIColor { get set }
    var cellTextColor: UIColor { get set }
    
    var cellAttributedText: [NSAttributedString.Key : Any] { get set }
}
