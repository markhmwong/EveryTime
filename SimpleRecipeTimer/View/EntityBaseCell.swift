//
//  BaseCell.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 2/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit
import SwipeCellKit

class EntityBaseCell<E>: SwipeCollectionViewCell {
    
    var entity: E?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        //
    }
    
    func prepareNameLabel(_ name: String) {
        
    }
    
    func prepareLabels(_ name: String, _ time: String) {
        
    }
    
}
