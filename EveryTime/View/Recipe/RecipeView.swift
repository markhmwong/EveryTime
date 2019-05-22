//
//  RecipeView.swift
//  EveryTime
//
//  Created by Mark Wong on 2/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class RecipeView: UIView {
    
    let stepCellId = "stepCellId"

    weak var delegate: RecipeViewControllerWithTableView?
    
    private lazy var navView: NavView? = nil

    lazy var headerView: HeaderView = {
        let view = HeaderView(theme: delegate?.viewModel?.theme)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Theme.Font.Color.TextColour, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Back", attributes: delegate?.viewModel?.theme?.currentTheme.navigation.item), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Theme.Font.Color.TextColour, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Settings", attributes: delegate?.viewModel?.theme?.currentTheme.navigation.item), for: .normal)
        button.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var pauseRecipeButton: StandardButton = {
        let button = StandardButton(title: "Pause", theme: delegate?.viewModel?.theme)
        button.addTarget(self, action: #selector(handlePauseRecipe), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let view: UITableView = UITableView()
//        view.delegate = self
        view.isEditing = false
//        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
//        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(delegate: RecipeViewControllerWithTableView) {
        self.init(frame: .zero)
        self.delegate = delegate
        self.setupView()
        self.setupAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        navView = NavView(frame: .zero, leftNavItem: dismissButton, rightNavItem: settingsButton, titleLabel: nil, topScreenAnchor: self.topAnchor)
        guard let nav = navView, let vm = delegate?.viewModel else {
            return
        }
        nav.backgroundFillerColor(color: vm.theme?.currentTheme.navigation.backgroundColor)

        tableView.backgroundColor = vm.theme?.currentTheme.tableView.backgroundColor
        
        tableView.delegate = delegate
        tableView.dataSource = delegate
        headerView.delegate = delegate
        headerView.theme = vm.theme
        tableView.tableHeaderView = headerView
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        addSubview(nav)
        addSubview(pauseRecipeButton)
        addSubview(tableView)
        addSubview(pauseRecipeButton)
        tableView.register(RecipeViewCell.self, forCellReuseIdentifier: stepCellId)
    }
    
    func setupAutoLayout() {
        guard let nav = navView else {
            return
        }
        
        guard let vm = delegate?.viewModel else {
            return
        }
        
        let navTopConstraint = !vm.appDelegate.hasTopNotch ? topAnchor : nil
        let heightByNotch = !vm.appDelegate.hasTopNotch ? Theme.View.Nav.HeightWithoutNotch : Theme.View.Nav.HeightWithNotch
        nav.anchorView(top: navTopConstraint, bottom: tableView.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        nav.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightByNotch).isActive = true
        
        pauseRecipeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -45.0).isActive = true
        pauseRecipeButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pauseRecipeButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.33).isActive = true
        
        tableView.anchorView(top: nav.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
    }
    
    func handleStepButtonAnimation(offset: CGFloat) {
        UIView.animate(withDuration: 0.2, delay: 0.2, options: [.curveEaseInOut], animations: {
            self.pauseRecipeButton.center.y = self.frame.maxY + offset
        }, completion: nil)
    }

    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        guard let nav = navView else {
            return
        }
        nav.topAnchor.constraint(equalTo: topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition

    }
    
    func handleRightNavItem(pauseState: Bool) {
        DispatchQueue.main.async {
            if (pauseState) {
                self.navView?.rightNavItem?.alpha = 1.0
                self.navView?.rightNavItem?.isEnabled = true
            } else {
                self.navView?.rightNavItem?.alpha = 0.3
                self.navView?.rightNavItem?.isEnabled = false
            }
        }
    }
    
    func handleSettingsButton(pauseState: Bool) {
        DispatchQueue.main.async {
            if (pauseState) {
                self.settingsButton.isEnabled = false
                self.settingsButton.alpha = 0.3
            } else {
                self.settingsButton.isEnabled = true
                self.settingsButton.alpha = 1.0
            }
        }
    }
    
    func handlePauseButton(pauseState: Bool) {
        if (pauseState) {
            DispatchQueue.main.async {
                self.pauseRecipeButton.updateButtonTitle(with: "Pause")
            }
        } else {
            DispatchQueue.main.async {
                self.pauseRecipeButton.updateButtonTitle(with: "Start")
            }
        }
    }
    
    @objc func handleDismiss() {
        guard let delegate = delegate else {
            return
        }
        delegate.dismissCurrentViewController()
    }
    
    @objc func handleSettings() {
        guard let delegate = delegate else {
            return
        }
        delegate.showSettings()
    }
    
    @objc func handlePauseRecipe() {
        guard let delegate = delegate else {
            return
        }
        delegate.handlePauseRecipe()
    }
}
