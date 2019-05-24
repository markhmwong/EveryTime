//
//  ThemeViewModel.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import StoreKit

class ThemeViewModel {
    typealias ProductIdentifier = String
    // References the sections in the theme table view
    enum ThemeType: Int {
        case FreeThemes
        case PaidThemes
    }
    
    enum FreeThemes: Int {
        case LightMint = 0
        case DarkMint
        case White
    }
    
    enum PaidThemes: String {
        case DeepMint = "deepminttheme"
        case Orange = "orangetheme"
        case Neutral = "neutraltheme"
        case Grape = "grapetheme"
    }
    
    var dataSource: [[String]] = [[StandardLightTheme.productIdentifier, StandardDarkTheme.productIdentifier, WhiteTheme.productIdentifier], ["Loading themes..."]]
    
    var paidProductsArr: [SKProduct] = []
    
    // Mark: - May need to be in the same order as the app store connect
    var availablePaidThemes: [ProductIdentifier] = [
        DeepMintTheme.productIdentifier,
        NeutralTheme.productIdentifier,
        OrangeTheme.productIdentifier,
        GrapeTheme.productIdentifier,
    ].sorted()
    
    var delegate: ThemeViewController?
    
    var theme: ThemeManager?
    
    var selectedTheme: ThemeProtocol?
    
    var lastSelection: IndexPath?

    let themeCellId = "ThemeCellId"
    
    init(theme: ThemeManager?) {
        self.theme = theme
    }
    
    func applyNewTheme(chosenTheme: ThemeProtocol) {
        if let theme = theme {
            ThemeManager.saveTheme(theme: resourceNameForProductIdentifier(chosenTheme.productIdentifier()) ?? "lightmint")
            theme.currentTheme = chosenTheme
            theme.currentTheme.applyTheme()
            delegate?.refreshView()
        }
    }
    
    func grabThemeProducts() {
        IAPProducts.store.requestProducts { [weak self](success, products) in
            guard let self = self else { return }
            if (success) {
                
                guard let products = products else { return }
                self.paidProductsArr = products
                self.dataSource[ThemeType.PaidThemes.rawValue].remove(at: 0) //remove loading cell
                for product in products {
                    self.dataSource[ThemeType.PaidThemes.rawValue].append(product.localizedTitle)
                }
                
                self.delegate?.mainView.tableView.reloadData()
            } else {
                self.dataSource[ThemeType.PaidThemes.rawValue].remove(at: 0) //remove loading cell
                self.dataSource[ThemeType.PaidThemes.rawValue].append("Trouble loading, please refresh")
                self.delegate?.mainView.tableView.reloadData()
            }
            self.delegate?.mainView.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func themeKeyForRow(indexPath: IndexPath) -> ThemeProtocol {
        
        if let type = ThemeType.init(rawValue: indexPath.section) {
            switch type {
            case .FreeThemes:
                return freeThemeKey(row: indexPath.row)
            case .PaidThemes:
                return paidThemeKey(row: indexPath.row)
            }
        }
        return StandardLightTheme()
    }
    
    func freeThemeKey(row: Int) -> ThemeProtocol {
        
        if let theme = FreeThemes.init(rawValue: row) {
            switch theme {
                case .LightMint:
                    return StandardLightTheme()
                case .DarkMint:
                    return StandardDarkTheme()
                case .White:
                    return WhiteTheme()
            }
        }
        return StandardLightTheme()
    }
    
    func paidThemeKey(row: Int) -> ThemeProtocol {
        
        let productFullId = availablePaidThemes[row]
        
        switch productFullId {
            case IAPProducts.DeepMintThemeId:
                return DeepMintTheme()
            case IAPProducts.NeutralId:
                return NeutralTheme()
            case IAPProducts.OrangeId:
                return OrangeTheme()
            case IAPProducts.GrapeId:
                return GrapeTheme()
            default:
                return StandardLightTheme()
        }
    }
}
