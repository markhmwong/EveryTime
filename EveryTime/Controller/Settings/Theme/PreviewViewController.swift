//
//  PreviewViewController.swift
//  EveryTime
//
//  Created by Mark Wong on 17/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import StoreKit

class PreviewViewController: ViewControllerBase {
    
    var theme: ThemeProtocol?
    
    weak var delegate: ThemeViewController?
    
    var hasBought: Bool?
    
    lazy var mainView: PreviewView = {
        let view = PreviewView(delegate: self, theme: theme, purchaseState: hasBought)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var closeButton: StandardButton = {
        guard let hasBought = hasBought else {
            let button = StandardButton(title: "Close", theme: ThemeManager.init(currentTheme: theme!))
            button.alpha = 0.7
            button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }
        
        let button = StandardButton(title: hasBought ? "Close" : "Maybe next time!", theme: ThemeManager.init(currentTheme: theme!))
        button.alpha = 0.7
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(delegate: ThemeViewController, theme: ThemeProtocol?, purchaseState: Bool?) {
        super.init(nibName: nil, bundle: nil)
        self.theme = theme
        self.delegate = delegate
        self.hasBought = purchaseState
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(closeModal), name: .IAPHelperPurchaseCancelledNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(completePurchase), name: .IAPHelperPurchaseCompleteNotification, object: nil)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.8)
        mainView.layer.cornerRadius = 5.0
        mainView.clipsToBounds = true
        view.addSubview(mainView)
        view.addSubview(closeButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainView.anchorView(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: view.centerYAnchor, centerX: view.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: -10.0), size: CGSize(width: 0.0, height: UIScreen.main.bounds.height / 2))
        
        closeButton.anchorView(top: mainView.bottomAnchor, bottom: nil, leading: mainView.leadingAnchor, trailing: mainView.trailingAnchor, centerY: nil, centerX: nil, padding: .init(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func handleDismiss() {
        NotificationCenter.default.removeObserver(self, name: .IAPHelperPurchaseCancelledNotification, object: nil)
        delegate?.dismissPreviewModal()
    }

    @objc func closeModal() {
        DispatchQueue.main.async {
            self.mainView.purchaseButton.updateLabel(string: "purchase cancelled..")
        }
    }
    
    @objc func completePurchase() {
        DispatchQueue.main.async {
            self.mainView.purchaseButton.updateLabel(string: "purchase complete")
        }
    }
    
    deinit {
//        print("deinit") not showing yet
    }
}

class PreviewView: UIView {
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        
        return formatter
    }()
    
    weak var delegate: PreviewViewController?
    
    var theme: ThemeProtocol?
    
    var hasBought: Bool?
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = theme?.navigation.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "00 : 00 : 00", attributes: theme?.font.stepTime)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var purchaseButton: StandardButton = {
        guard let hasBought = hasBought else {
            let button = StandardButton(title: "Purchase", theme: ThemeManager.init(currentTheme: theme!))
            button.alpha = 1.0
            button.addTarget(self, action: #selector(handlePurchase), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }
        
        let button = StandardButton(title: hasBought ? "Apply" : "Purchase (price here)", theme: ThemeManager.init(currentTheme: theme!))
        button.alpha = 1.0
        button.addTarget(self, action: #selector(handlePurchase), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(delegate: PreviewViewController, theme: ThemeProtocol?, purchaseState: Bool?) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.theme = theme
        self.hasBought = purchaseState
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        guard let theme = theme else { return }
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = theme.generalBackgroundColour
        
        descriptionLabel.attributedText = NSAttributedString(string: "\(theme.description)", attributes: theme.font.bodyText)
        titleLabel.attributedText = NSAttributedString(string: "\(theme.name) Preview", attributes: theme.navigation.title)

        addSubview(topView)
        addSubview(bottomView)
        addSubview(purchaseButton)
        topView.addSubview(descriptionLabel)
        topView.addSubview(titleLabel)
        bottomView.addSubview(timeLabel)
        
    }
    
    override func layoutSubviews() {
        topView.anchorView(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: bounds.height / 5))
        bottomView.anchorView(top: topView.bottomAnchor, bottom: bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        titleLabel.anchorView(top: nil, bottom: nil, leading: nil, trailing: nil, centerY: topView.centerYAnchor, centerX: topView.centerXAnchor, padding: .zero, size: .zero)
        timeLabel.anchorView(top: nil, bottom: nil, leading: nil, trailing: nil, centerY: centerYAnchor, centerX: centerXAnchor, padding: .zero, size: .zero)
        purchaseButton.anchorView(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: bounds.height / 6))
        descriptionLabel.anchorView(top: titleLabel.bottomAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
    }
    
    @objc func handlePurchase() {
        guard let hasBought = hasBought else { return }
        if (hasBought) {
            // apply theme
            guard let theme = theme else { return }
            guard let themeViewController = delegate?.delegate else { return }
            themeViewController.dismissPreviewModal()
            themeViewController.changeTheme(themeProtocol: theme)
        } else {
            // buy theme
            guard let themeViewController = delegate?.delegate else { return }
            let arr = themeViewController.viewModel?.paidProductsArr.filter({ (product) -> Bool in
                return product.productIdentifier == theme?.productIdentifier()
            })
            let product = arr?[0]

            IAPProducts.store.buyProduct(product!)
            DispatchQueue.main.async {
                self.purchaseButton.updateLabel(string: "one moment...")
            }

//            themeViewController.dismissPreviewModal()
        }
    }

    func updateActionButton(_ product: SKProduct?) {
        guard let hasBought = hasBought else { return }
        if (hasBought) {
            self.purchaseButton.updateLabel(string: "Apply theme")
        } else {
            guard let product = product else {
                self.purchaseButton.updateLabel(string: "N/A")
                self.purchaseButton.isEnabled = false
                return
            }
            
            PreviewView.priceFormatter.locale = product.priceLocale
            if let price = ThemeTableViewCell.priceFormatter.string(from: product.price) {
                DispatchQueue.main.async {
                    self.purchaseButton.updateLabel(string: "Buy theme: \(price)")
                }
            }
        }
    }
}
