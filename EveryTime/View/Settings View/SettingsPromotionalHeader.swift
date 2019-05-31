//
//  SettingsPromotionalHeader.swift
//  EveryTime
//
//  Created by Mark Wong on 22/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import StoreKit

class SettingsPromotionalHeader: UIView {
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        
        return formatter
    }()
    
//    lazy var CoffeeTip
    // beer money tip
    var viewModel: PromoHeaderViewModel?
    
    lazy var coffeeTip: StandardButton = {
       let button = StandardButton(title: "Short Tip N/A", theme: self.theme)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(handleCoffeeTip), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var generousTip: StandardButton = {
        let button = StandardButton(title: "Tall Tip N/A", theme: self.theme)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center

        button.addTarget(self, action: #selector(handleGenerousTip), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var amazingTip: StandardButton = {
        let button = StandardButton(title: "Grande Tip N/A", theme: self.theme)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center

        button.addTarget(self, action: #selector(handleAmazingTip), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var promoText: UITextView = {
       let view = UITextView()
        view.textColor = .black
        view.isSelectable = false
        view.isEditable = false
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    weak var delegate: SettingsMainView?
    
    var theme: ThemeManager?
    
    convenience init(delegate: SettingsMainView, theme: ThemeManager?) {
        self.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false

        self.delegate = delegate
        self.theme = theme
        self.viewModel = PromoHeaderViewModel()
        self.setupView()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        anchorView(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: UIScreen.main.bounds.height * 0.2))

        addSubview(coffeeTip)
        addSubview(generousTip)
        addSubview(amazingTip)
        
        viewModel?.buttonArr.append(coffeeTip)
        viewModel?.buttonArr.append(generousTip)
        viewModel?.buttonArr.append(amazingTip)


        addSubview(promoText)
        promoText.isScrollEnabled = false
        promoText.attributedText = NSAttributedString(string: "EveryTime relies on your support to fund its development.\nIf you find it useful for your daily activities, please consider supporting the app by leaving a tip in my tip jar.", attributes: theme?.currentTheme.font.bodyText)
        promoText.textContainer.lineBreakMode = .byWordWrapping
        promoText.sizeToFit()
        promoText.textAlignment = .center
        promoText.anchorView(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 0.0))
    }
    
    func grabTipsProducts() {
        IAPProducts.tipStore.requestProducts { [weak self](success, products) in
            guard let self = self else { return }
        
            if (success) {
                guard let products = products else { return }
                self.viewModel?.tipProducts = products
                //update buttons
                self.updateTipButtons()
            } else {
                // requires internet access
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        coffeeTip.anchorView(top: generousTip.topAnchor, bottom: nil, leading: nil, trailing: generousTip.leadingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -10.0), size: CGSize(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.1))
        generousTip.anchorView(top: promoText.bottomAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.1))
        amazingTip.anchorView(top: generousTip.topAnchor, bottom: nil, leading: generousTip.trailingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0), size: CGSize(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.1))
    }
    
    func updateTipButtons() {
        guard let tipProductArr = self.viewModel?.tipProducts else { return } //tips are sorted with didSet observer
        let buttonArr = viewModel?.buttonArr
        if (buttonArr!.count == tipProductArr.count) {
            for (index, button) in buttonArr!.enumerated() {
                SettingsPromotionalHeader.priceFormatter.locale = tipProductArr[index].priceLocale
                let price = SettingsPromotionalHeader.priceFormatter.string(from: tipProductArr[index].price)
                button.setAttributedTitle(NSAttributedString(string: "\(tipProductArr[index].localizedTitle) \(price!)", attributes: self.theme?.currentTheme.font.bodyText), for: .normal)
                button.product = tipProductArr[index]
                button.buyButtonHandler = { product in
                    IAPProducts.tipStore.buyProduct(product)
                }
            }
        }
    }
    
    @objc func handleCoffeeTip(_ button: StandardButton) {
        button.buyButtonHandler?(button.product!)
    }
    
    @objc func handleGenerousTip(_ button: StandardButton) {
        button.buyButtonHandler?(button.product!)
    }
    
    @objc func handleAmazingTip(_ button: StandardButton) {
        button.buyButtonHandler?(button.product!)

    }
}
