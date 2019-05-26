//
//  ThemeView.swift
//  EveryTime
//
//  Created by Mark Wong on 6/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class ThemeView: UIView {
    
    weak var delegate: ThemeViewController?
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Back", attributes: delegate?.viewModel?.theme?.currentTheme.navigation.item), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var restoreButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Restore", attributes: delegate?.viewModel?.theme?.currentTheme.navigation.item), for: .normal)
        button.addTarget(self, action: #selector(handleRestore), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Theme", attributes: delegate?.viewModel?.theme?.currentTheme.navigation.title)
        return label
    }()
    
    lazy var navView: NavView = {
        let view = NavView(frame: .zero, leftNavItem: dismissButton, rightNavItem: restoreButton, titleLabel: titleLabel, topScreenAnchor: self.topAnchor)
        view.backgroundFillerColor(color: delegate?.viewModel?.theme?.currentTheme.navigation.backgroundColor)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    init(delegate: ThemeViewController) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.setupView()
        self.setupAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func headerView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.fillSuperView()

        
        let label = UILabel()
        label.text = "Touch for preview"
        label.textColor = .red
        label.backgroundColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.fillSuperView()
        
        view.addSubview(label)
        return view
    }
    
    func setupView() {
        guard let vm = delegate?.viewModel else {
            return
        }

        backgroundColor = vm.theme?.currentTheme.generalBackgroundColour
        addSubview(tableView)
        addSubview(navView)
        tableView.register(ThemeTableViewCell.self, forCellReuseIdentifier: vm.themeCellId)
    }
    
    func setupAutoLayout() {
        let navTopConstraint = !appDelegate.hasTopNotch ? topAnchor : nil
        let heightByNotch = !appDelegate.hasTopNotch ? Theme.View.Nav.HeightWithoutNotch : Theme.View.Nav.HeightWithNotch
        
        navView.anchorView(top: navTopConstraint, bottom: tableView.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        navView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightByNotch).isActive = true
        tableView.anchorView(top: navView.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        if (appDelegate.hasTopNotch) {
            let safeAreaInsets = self.safeAreaInsets
            navView.topAnchor.constraint(equalTo: topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
        }
    }
    
    @objc func handleDismiss() {
        delegate?.handleDismiss()
    }
    
    @objc func handleRestore() {
        IAPProducts.store.restorePurchases()
    }
}

extension ThemeView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Touch for a preview"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) {
            guard let sectionArr = delegate?.viewModel?.dataSource[section] else {
                return 0
            }
            return sectionArr.count
        }
        
        if (section == 1) {
            guard let vm = delegate?.viewModel else {
                return 0
            }
            
            return vm.availablePaidThemes.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: (delegate?.viewModel?.themeCellId)!, for: indexPath) as! ThemeTableViewCell
        guard let vm = delegate?.viewModel else {
            cell.textLabel?.text = "No Theme"
            return cell
        }
        
        cell.theme = vm.theme
        let currentAppliedTheme: String = "com.whizbang.Everytime.\(KeychainWrapper.standard.string(forKey: ThemeManager.currentAppliedThemeKey) ?? "lightmint")"

        cell.backgroundColor = vm.theme?.currentTheme.tableView.cellBackgroundColor

        if (indexPath.section == 0) {
            let fullId = vm.dataSource[indexPath.section][indexPath.row]
            let themeProtocol = ThemeManager.themeFactory(resourceNameForProductIdentifier(fullId)!)

            cell.textLabel?.attributedText = NSAttributedString(string: themeProtocol.name, attributes: vm.theme?.currentTheme.tableView.settingsCell)

            if (currentAppliedTheme == fullId) {
                if let cellAttributedText = cell.textLabel?.attributedText {
                    cell.textLabel?.attributedText = NSAttributedString(string: "\(cellAttributedText.string) Applied", attributes: vm.theme?.currentTheme.tableView.settingsCell)
                }
            }
        }
        
        if (indexPath.section == 1) {
            cell.availableThemes = vm.availablePaidThemes[indexPath.row]
            if (!vm.paidProductsArr.isEmpty) {
                cell.product = vm.paidProductsArr[indexPath.row]
                cell.buyButtonHandler = { product in
                    IAPProducts.store.buyProduct(product)
                }
            }
            if (currentAppliedTheme == vm.availablePaidThemes[indexPath.row]) {
                if let cellAttributedText = cell.textLabel?.attributedText {
                    cell.textLabel?.attributedText = NSAttributedString(string: "\(cellAttributedText.string) Applied", attributes: vm.theme?.currentTheme.tableView.settingsCell)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vm = delegate?.viewModel else { return }
        delegate?.viewModel?.lastSelection = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        
        //present new viewcontroller
        var themeProtocol: ThemeProtocol?
        
        if (indexPath.section == 0) {
            if let theme = delegate?.viewModel!.themeKeyForRow(indexPath: indexPath) {
                themeProtocol = theme
                guard let selectedTheme = themeProtocol else { return }

                delegate?.showPreview(selectedTheme, nil)
            }
        }
        
        if (indexPath.section == 1) {
            if let theme = delegate?.viewModel!.themeKeyForRow(indexPath: indexPath) {
                themeProtocol = theme
                guard let selectedTheme = themeProtocol else { return }
                if (vm.paidProductsArr.count == 0) {
                    delegate?.showPreview(selectedTheme, nil)
                } else {
                    delegate?.showPreview(selectedTheme, vm.paidProductsArr[indexPath.row])
                }

            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
    }
}
