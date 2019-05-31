//
//  PromoHeaderViewModel.swift
//  EveryTime
//
//  Created by Mark Wong on 23/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import StoreKit

class PromoHeaderViewModel {
    var tipProducts: [SKProduct]? {
        didSet {
            self.tipProducts?.sort(by: { (a, b) -> Bool in
                return Unicode.CanonicalCombiningClass(rawValue: UInt8(truncating: a.price)) < Unicode.CanonicalCombiningClass(rawValue: UInt8(truncating: b.price))
            })
        }
    }
    var buttonArr: [StandardButton] = []
}
