//
//  Theme.swift
//  EveryTime
//
//  Created by Mark Wong on 5/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class ThemeManager {
    var currentTheme: ThemeProtocol
    
    init(currentTheme: ThemeProtocol = StandardLightTheme()) {
        self.currentTheme = currentTheme
    }
}



//struct StandardLightTheme: ThemeProtocol {
//    var view: View = View()
//    func applyTheme() {
//
//        NavView.appearance().backgroundColor = UIColor.blue
//    }
//}

//struct StandardDarkTheme: ThemeProtocol {
//    var view: View
//
//    func applyTheme() {
//        NavView.appearance().backgroundColor = UIColor.black
//    }
//}
//
//struct OledDarkTheme: ThemeProtocol {
//    var view: View
//
//    func applyTheme() {
//        NavView.appearance().backgroundColor = UIColor.black
//    }
//}
