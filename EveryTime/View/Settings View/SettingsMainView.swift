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
        case Appearance
        case Support
        case ChangeLog
    }
    
    enum Appearance: Int {
        case themes
        case purchasableThemes
    }
    
    enum Support: Int {
        case About
        case Review
        case Share
        case Feedback
        case WhatsNew
    }
    
    let settingsCellId = "settingsCellId"
    
    var delegate: SettingsViewController?
    
    private var mainViewControllerDelegate: MainViewController?
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Back", attributes: delegate?.viewModel?.theme?.currentTheme.navigation.item), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var tableView: UITableView = {
       let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Settings", attributes: delegate?.viewModel?.theme?.currentTheme.navigation.title)
        return label
    }()
    
    private lazy var navView: NavView = {
        let view = NavView(frame: .zero, leftNavItem: dismissButton, rightNavItem: nil, titleLabel: titleLabel, topScreenAnchor: self.topAnchor)
        view.backgroundFillerColor(color: delegate?.viewModel?.theme?.currentTheme.navigation.backgroundColor)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(delegate: SettingsViewController) {
        self.init(frame: .zero)
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
        
        tableView.backgroundColor = vm.theme?.currentTheme.tableView.backgroundColor
        addSubview(tableView)
        addSubview(navView)
        tableView.register(SettingsViewCell.self, forCellReuseIdentifier: settingsCellId)
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

extension SettingsMainView: UITableViewDelegate, UITableViewDataSource {
    func appearance(row: Int) {
        
        guard let delegate = delegate else {
            return
        }

        
        guard let appearance = Appearance(rawValue: row) else { return }
        
        switch appearance {
        case .themes:
            let vc = ThemeViewController(delegate: delegate, viewModel: ThemeViewModel(theme: delegate.viewModel?.theme))
            vc.viewModel?.delegate = vc
            DispatchQueue.main.async {
                delegate.present(vc, animated: true, completion: nil)
            }
        case .purchasableThemes:
            () //to be done
        }
        
    }
    func about(row: Int) {
        
        guard let svc = delegate else {
            return
        }
        
        guard let support = Support(rawValue: row) else {
            return
        }
        
        switch support {
            case .About:
                guard let theme = svc.viewModel?.theme else {
                    return
                }
                let vc = AboutViewController(viewModel: AboutViewModel(theme: theme))
                DispatchQueue.main.async {
                    svc.present(vc, animated: true, completion: nil)
                }
            case .Review:
                writeReview()
            case .Share:
                svc.share()
            case .Feedback:
                svc.emailFeedback()
            default:
                break
        }
    }
    
    func writeReview() {
        let productURL = URL(string: "https://itunes.apple.com/app/id1454444680?mt=8")!
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        
        // 2.
        components?.queryItems = [
            URLQueryItem(name: "action", value: "write-review")
        ]
        
        // 3.
        guard let writeReviewURL = components?.url else {
            return
        }
        
        // 4.
        UIApplication.shared.open(writeReviewURL)
    }
    
    //https://itunes.apple.com/app/id1454444680?mt=8
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            return
        }
        
        guard let settingsSections = SettingsSections(rawValue: indexPath.section) else {
            return
        }
        guard let theme = delegate.viewModel?.theme else {
            return
        }
        
        switch settingsSections {
            case .Data:
                if (indexPath.row == Data.Clear.rawValue) {
                    delegate.deleteAllAction()
                }
            case .Appearance:
                appearance(row: indexPath.row)

            case .Support:
                about(row: indexPath.row)
            case .ChangeLog:
                let vc = SettingsWhatsNewViewController(delegate: delegate, viewModel: WhatsNewViewModel(whatsNew: WhatsNewFactory.getLatestWhatsNew(), theme: theme))
                DispatchQueue.main.async {
                    delegate.present(vc, animated: true, completion: nil)
                }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.viewModel?.dataSource[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellId, for: indexPath) as! SettingsViewCell
        cell.theme = delegate?.viewModel?.theme
        cell.updateLabel(text: delegate?.viewModel?.dataSource[indexPath.section][indexPath.row] ?? "Unknown Setting")
        if (indexPath.section == SettingsSections.Data.rawValue && indexPath.item == Data.Clear.rawValue) {
            cell.label.textColor = UIColor.red
        } else {
            cell.label.textColor = delegate?.viewModel?.theme?.currentTheme.font.TextColour
            cell.imageView.image = UIImage(named: "Reset_Dark")
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
            case .Appearance:
                return "Appearance"
            case .Support:
                return "Support"
            case .ChangeLog:
                return "Change Log"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return delegate?.viewModel?.dataSource.count ?? 0
    }
}
