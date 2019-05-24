//
//  ThemeViewController.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import StoreKit

class ThemeViewController: ViewControllerBase {
    
    weak var delegate: SettingsViewController?
    
    var viewModel: ThemeViewModel?
    
    var applyTheme: ThemeProtocol?
    
    enum PreviewViewState {
        case closed
        case open
    }
    var runningAnimations = [UIViewPropertyAnimator]()
    private var bottomConstraint = NSLayoutConstraint()
    var previewVisible: Bool = false
    var previewCurrentState: PreviewViewState {
        return previewVisible ? PreviewViewState.open : PreviewViewState.closed
    }
    
    lazy var mainView: ThemeView = {
        let view = ThemeView(delegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.0
        return view
    }()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(delegate: SettingsViewController, viewModel: ThemeViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareViewController() {
        super.prepareViewController()
    }
    
    override func prepareView() {
        super.prepareView()
        view.addSubview(mainView)

        mainView.backgroundColor = viewModel?.theme?.currentTheme.generalBackgroundColour
        mainView.tableView.reloadData()
        
        viewModel?.grabThemeProducts()
    }
    
    @objc func restorePurchases() {
        
    }
    
    override func prepareAutoLayout() {
        super.prepareAutoLayout()
        mainView.fillSuperView()
    }
    
    func handleDismiss() {
        delegate?.mainView?.tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func changeTheme(themeProtocol: ThemeProtocol) {
        guard let vm = viewModel else {
            return
        }
        vm.applyNewTheme(chosenTheme: themeProtocol)
    }
    
    func refreshView() {
        mainView.navView.backgroundColor = viewModel?.theme?.currentTheme.navigation.backgroundColor
        mainView.navView.backgroundFillerColor(color: viewModel?.theme?.currentTheme.navigation.backgroundColor)
        mainView.navView.leftNavItem?.setAttributedTitle(NSAttributedString(string: "Back", attributes: viewModel?.theme?.currentTheme.navigation.item), for: .normal)
        mainView.navView.rightNavItem?.setAttributedTitle(NSAttributedString(string: "Restore", attributes: viewModel?.theme?.currentTheme.navigation.item), for: .normal)
        mainView.navView.titleLabel?.attributedText = NSAttributedString(string: "Theme", attributes: viewModel?.theme?.currentTheme.navigation.title)
        
        mainView.backgroundColor = viewModel?.theme?.currentTheme.generalBackgroundColour
        mainView.tableView.backgroundColor = viewModel?.theme?.currentTheme.tableView.backgroundColor
        mainView.tableView.reloadData()
        view.layoutIfNeeded()
    }
    
    var previewViewController: PreviewViewController?
    
    func showPreview(_ selectedTheme: ThemeProtocol, _ product: SKProduct?) {
        if (previewViewController == nil) {
            let hasBought = KeychainWrapper.standard.bool(forKey: selectedTheme.productIdentifier())
            previewViewController = PreviewViewController(delegate: self, theme: selectedTheme, purchaseState: hasBought)
            guard let previewViewController = previewViewController else { return }
            addChild(previewViewController)
            view.addSubview(previewViewController.view)
            previewViewController.view.fillSuperView()
            previewViewController.view.alpha = 0.0
            previewVisible = true
            animateTransitionIfNeeded(state: previewCurrentState)
        }
        previewViewController?.mainView.updateActionButton(product)
    }

    
    func animateTransitionIfNeeded(state: PreviewViewState) {
        let duration = 0.2
        guard runningAnimations.isEmpty else {
            return
        }
        
        let popOverAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.75) {
            switch state {
            case PreviewViewState.open:
                self.previewViewController?.view.alpha = 1.0
            case PreviewViewState.closed:
                self.previewViewController?.view.alpha = 0.0
                self.previewViewController = nil
            }
        }
        popOverAnimator.addCompletion { (position) in
            switch position {
            case .start:
                self.previewVisible = true
            case .end:
                self.previewVisible = !self.previewVisible
            case .current:
                ()
            }
            self.runningAnimations.removeAll()
            
        }
        popOverAnimator.startAnimation()
        runningAnimations.append(popOverAnimator)
    }

    func dismissPreviewModal() {
        previewVisible = false
        animateTransitionIfNeeded(state: previewCurrentState)

    }
}

