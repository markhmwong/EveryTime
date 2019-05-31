//
//  ThemeTableViewCell.swift
//  EveryTime
//
//  Created by Mark Wong on 7/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import StoreKit

/// Set this class up for UIAppearance
class ThemeTableViewCell: UITableViewCell {
    
    var theme: ThemeManager?
    
    var delegate: ThemeViewController?
    
    var buyButtonHandler: ((_ product: SKProduct) -> Void)?

    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        
        return formatter
    }()
    
    
    
    // MARK: - These are product identifiers
    var availableThemes: String? {
        didSet {
            guard let availableThemes = availableThemes else { return }
            guard let theme = theme else { return }
            guard let name = resourceNameForProductIdentifier(availableThemes) else { return }
            let themeProtocol = ThemeManager.themeFactory(name)
            textLabel?.attributedText = NSAttributedString(string: themeProtocol.name, attributes: theme.currentTheme.tableView.settingsCell)
        }
    }
    
    var product: SKProduct? {
        didSet {
            guard let product = product, let theme = theme else { return }
            
            textLabel?.attributedText = NSAttributedString(string: product.localizedTitle, attributes: theme.currentTheme.tableView.settingsCell)
            
            if IAPProducts.store.isProductPurchased(product.productIdentifier) || KeychainWrapper.standard.bool(forKey: product.productIdentifier)! {
                tintColor = theme.currentTheme.tableView.pauseButtonBackgroundActive
                accessoryType = .checkmark
                accessoryView = nil
            } else if IAPHelper.canMakePayments() {
                ThemeTableViewCell.priceFormatter.locale = product.priceLocale
                let price = ThemeTableViewCell.priceFormatter.string(from: product.price)
                accessoryType = .detailButton
                accessoryView = self.newBuyButton(price)
            } else {
                detailTextLabel?.text = "Not available"
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {

    }
    
    func newBuyButton(_ price: String?) -> UIButton {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(ThemeTableViewCell.buyButtonTapped(_:)), for: .touchUpInside)
        button.layer.borderColor = theme?.currentTheme.tableView.cellTextColor.cgColor
        button.layer.cornerRadius = 3.0
        button.layer.borderWidth = 1.0
        button.contentEdgeInsets = UIEdgeInsets(top: 7.0, left: 7.0, bottom: 7.0, right: 7.0)
        
        guard let price = price else {
            button.setAttributedTitle(NSAttributedString(string: "N/A", attributes: theme?.currentTheme.tableView.settingsCell), for: .normal)
            button.sizeToFit()
            return button
        }
        button.setAttributedTitle(NSAttributedString(string: price, attributes: theme?.currentTheme.tableView.settingsCell), for: .normal)
        button.sizeToFit()
        return button
    }
    
    
    @objc func buyButtonTapped(_ sender: AnyObject) {
        buyButtonHandler?(product!)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = ""
        detailTextLabel?.text = ""
        accessoryView = nil
    }
}

class ThemeCellLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
