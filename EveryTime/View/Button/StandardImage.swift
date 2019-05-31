//
//  StandardImage.swift
//  EveryTime
//
//  Created by Mark Wong on 23/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class StandardImage: UIImage {
    
    convenience init(name: String) {
        let image = UIImage(named: name)
        self.init(cgImage: (image?.cgImage)!)
        
        self.withRenderingMode(.alwaysTemplate)
        
    }
    
}
