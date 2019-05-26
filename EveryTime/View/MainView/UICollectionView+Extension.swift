//
//  UICollectionView+Extension.swift
//  EveryTime
//
//  Created by Mark Wong on 26/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func setEmptyMessage(_ message: String, theme: ThemeManager?, delegate: MainViewController) {
        guard let theme = theme else { return }
        self.backgroundView = EmptyCollectionView(delegate: delegate,theme: theme)
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
