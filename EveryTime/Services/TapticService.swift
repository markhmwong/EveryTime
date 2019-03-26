//
//  TapticService.swift
//  EveryTime
//
//  Created by Mark Wong on 26/3/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class TapticService {
    
    class var shared: TapticService {
        struct Static {
            static let instance: TapticService = TapticService()
        }
        return Static.instance
    }
    
}
