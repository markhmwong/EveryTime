//
//  AboutMainView.swift
//  EveryTime
//
//  Created by Mark Wong on 21/3/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import StoreKit

class SettingsMainView: UIView {
    enum Data: Int {
        case Clear
    }
    
    enum SettingsSections: Int {
        case Data
        case Support
        case ChangeLog
    }
    
    enum Support: Int {
        case About
        case Review
        case Share
        case Feedback
        case WhatsNew
    }
    
    let settingsCellId = "settingsCellId"
    
    var settingsViewControllerDelegate: SettingsViewController?
    
    private var mainViewControllerDelegate: MainViewController?
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Back", attributes: Theme.Font.Nav.Item), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var navView: NavView = {
       let view = NavView(frame: .zero, leftNavItem: dismissButton, rightNavItem: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Info", attributes: Theme.Font.Nav.AppName)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(delegate: SettingsViewController) {
        self.init(frame: .zero)
        self.settingsViewControllerDelegate = delegate
        self.setupView()
        self.setupAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(tableView)
        addSubview(navView)
        navView.addSubview(titleLabel)
        tableView.register(SettingsViewCell.self, forCellReuseIdentifier: settingsCellId)
    }
    
    func setupAutoLayout() {
        let navTopConstraint = !appDelegate.hasTopNotch ? topAnchor : nil
        let heightByNotch = !appDelegate.hasTopNotch ? Theme.View.Nav.HeightWithoutNotch : Theme.View.Nav.HeightWithNotch
        
        navView.anchorView(top: navTopConstraint, bottom: tableView.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        navView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightByNotch).isActive = true

        titleLabel.anchorView(top: nil, bottom: nil, leading: nil, trailing: nil, centerY: navView.centerYAnchor, centerX: centerXAnchor, padding: .zero, size: .zero)
        
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
        settingsViewControllerDelegate?.handleDismiss()
    }
}

extension SettingsMainView: UITableViewDelegate, UITableViewDataSource {
    /// Rows for the about section
    func about(row: Int) {
        
        guard let svc = settingsViewControllerDelegate else {
            return
        }
        
        guard let support = Support(rawValue: row) else {
            return
        }
        
        switch support {
            case .About:
                let vc = AboutViewController()
                DispatchQueue.main.async {
                    svc.present(vc, animated: true, completion: nil)
                }
            case .Review:
                SKStoreReviewController.requestReview()
            case .Share:
                svc.share()
            case .Feedback:
                svc.emailFeedback()
            default:
                break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let svc = settingsViewControllerDelegate else {
            return
        }
        
        guard let settingsSections = SettingsSections(rawValue: indexPath.section) else {
            return
        }
        
        switch settingsSections {
            case .Data:
                if (indexPath.row == Data.Clear.rawValue) {
                    svc.deleteAllAction()
                }
            case .Support:
                about(row: indexPath.row)
            case .ChangeLog:
                let vc = SettingsWhatsNewViewController(delegate: svc)
                DispatchQueue.main.async {
                    svc.present(vc, animated: true, completion: nil)
                }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsViewControllerDelegate!.settingsViewModel.dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellId, for: indexPath) as! SettingsViewCell
        cell.updateLabel(text: settingsViewControllerDelegate!.settingsViewModel.dataSource[indexPath.section][indexPath.row])
        if (indexPath.section == SettingsSections.Data.rawValue && indexPath.item == Data.Clear.rawValue) {
            cell.label.textColor = UIColor.red
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 22
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let settingsSection = SettingsSections(rawValue: section) else {
            return "Unknown Section"
        }
        
        switch settingsSection {
            case .Data:
                return "Data"
            case .Support:
                return "Support"
            case .ChangeLog:
                return "Change Log"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsViewControllerDelegate!.settingsViewModel.dataSource.count
    }
    

}
