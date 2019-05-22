//
//  IAPProducts.swift
//  EveryTime
//
//  Created by Mark Wong on 14/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

public struct IAPProducts {

    public static let productArray: Set = [
        OrangeTheme.productIdentifier,
        NeutralTheme.productIdentifier,
        DeepMintTheme.productIdentifier,
    ]
    
    private static let productIdentifiers: Set<ProductIdentifier> = productArray
    
    public static let store = IAPHelper(productIds: IAPProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}

extension IAPProducts {
    public static let DeepMintThemeId = DeepMintTheme.productIdentifier
    public static let OrangeId = OrangeTheme.productIdentifier
    public static let NeutralId = NeutralTheme.productIdentifier
    public static let WhiteId = WhiteTheme.productIdentifier

}
