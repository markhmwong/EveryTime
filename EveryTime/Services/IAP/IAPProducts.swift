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
        GrapeTheme.productIdentifier,
    ]
    
    public static let tipProductArray: Set = [
        IAPProducts.shortId,
        IAPProducts.tallId,
        IAPProducts.grandeId,
    ]
    
    private static let productIdentifiers: Set<ProductIdentifier> = productArray
    private static let tipProductIdentifiers: Set<ProductIdentifier> = tipProductArray
    
    public static let store = IAPHelper(productIds: IAPProducts.productIdentifiers)
    public static let tipStore = IAPHelper(productIds: IAPProducts.tipProductIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}

func resourceNameByCategory(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".")[2] // Index 2 is the category - theme, tips
}

extension IAPProducts {
    public static let DeepMintThemeId = DeepMintTheme.productIdentifier
    public static let OrangeId = OrangeTheme.productIdentifier
    public static let NeutralId = NeutralTheme.productIdentifier
    public static let WhiteId = WhiteTheme.productIdentifier
    public static let GrapeId = GrapeTheme.productIdentifier

    public static let shortId = "com.whizbang.Everytime.tip.short"
    public static let tallId = "com.whizbang.Everytime.tip.tall"
    public static let grandeId = "com.whizbang.Everytime.tip.grande"

}
