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
        button.setAttributedTitle(NSAttributedString(string: "Back", attributes: delegate?.viewModel?.theme?.currentTheme.navigation.navigationItem), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Theme", attributes: delegate?.viewModel?.theme?.currentTheme.navigation.navigationItem)
        return label
    }()
    
    private lazy var navView: NavView = {
        let view = NavView(frame: .zero, leftNavItem: dismissButton, rightNavItem: nil, titleLabel: titleLabel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
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
    
    func setupView() {
        guard let vm = delegate?.viewModel else {
            return
        }
        backgroundColor = vm.theme?.currentTheme.navigation.backgroundColor
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
}

extension ThemeView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let vm = delegate?.viewModel else {
            return 0
        }
        return vm.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: (delegate?.viewModel?.themeCellId)!, for: indexPath) as! ThemeTableViewCell
        if let vm = delegate?.viewModel {
            cell.textLabel?.text = vm.dataSource[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let lastSelection = delegate?.viewModel?.lastSelection  {
            tableView.cellForRow(at: lastSelection)?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        delegate?.viewModel?.lastSelection = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        
        //load new theme
        guard let delegate = delegate else {
            return
        }
        
        delegate.changeTheme(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
    }
}
