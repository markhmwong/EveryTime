//
//  HeaderView.swift
//  EveryTime
//
//  Created by Mark Wong on 23/3/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    var delegate: RecipeViewControllerWithTableView?
    
    var theme: ThemeManager?
    
    private lazy var innerPaddedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Unknown Name", attributes: Theme.Font.Recipe.HeaderTableView)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var headerStepTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var headerStepTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var headerNextStepLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var headerNextStepTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var headerNextStepTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var fullScreenButton: UIButton = {
        let button = UIButton()
        let appliedTheme = theme?.currentTheme.productIdentifier()
        
        //needs to be updated, maybe create a light/dark theme classifier and tint it like mainview cell
        switch appliedTheme {
            case StandardDarkTheme.productIdentifier, DeepMintTheme.productIdentifier:
                button.setImage(UIImage(named: "FullScreenLight.png"), for: .normal)
            case StandardLightTheme.productIdentifier, NeutralTheme.productIdentifier, OrangeTheme.productIdentifier, WhiteTheme.productIdentifier, GrapeTheme.productIdentifier:
                button.setImage(UIImage(named: "FullScreenDark.png"), for: .normal)
            default:
                button.setImage(UIImage(named: "FullScreenLight.png"), for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var saveButton: StandardButton = {
        let button = StandardButton(title:"Save", theme: theme)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0.0
        button.isEnabled = false
        return button
    }()

    convenience init(theme: ThemeManager?) {
        self.init()
        self.theme = theme
        self.setupView()
        self.setupAutoLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.clear
        addSubview(innerPaddedView)
        guard let theme = theme else {
            return
        }
        
        fullScreenButton.addTarget(self, action: #selector(handleFullScreen), for: .touchUpInside)
        innerPaddedView.addSubview(fullScreenButton)
        
        headerTitleLabel.attributedText = NSAttributedString(string: "No name", attributes: theme.currentTheme.tableView.recipeHeaderRecipe)
        innerPaddedView.addSubview(headerTitleLabel)
        innerPaddedView.addSubview(headerStepTimeLabel)
        innerPaddedView.addSubview(headerStepTitleLabel)
        innerPaddedView.addSubview(headerNextStepTitleLabel)
        innerPaddedView.addSubview(headerNextStepTimeLabel)
        headerNextStepLabel.attributedText = NSAttributedString(string: "Next Step", attributes: theme.currentTheme.tableView.recipeSubtitle)
        innerPaddedView.addSubview(headerNextStepLabel)
        
        innerPaddedView.addSubview(saveButton)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        guard let vm = delegate?.viewModel else {
            fullScreenButton.anchorView(top: innerPaddedView.topAnchor, bottom: nil, leading: nil, trailing: innerPaddedView.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: -10.0), size: CGSize(width: 18.0, height: 18.0))
            return
        }
        
        fullScreenButton.anchorView(top: innerPaddedView.topAnchor, bottom: nil, leading: nil, trailing: innerPaddedView.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: -10.0), size: vm.fullScreenButtonSize)
        
        innerPaddedView.anchorView(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        headerTitleLabel.anchorView(top: innerPaddedView.topAnchor, bottom: nil, leading: innerPaddedView.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: 30.0, bottom: 0, right: 0), size: .zero)
        headerStepTimeLabel.anchorView(top: headerTitleLabel.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 20.0, left: 30.0, bottom: 0.0, right: 0.0), size: .zero)
        headerStepTitleLabel.anchorView(top: headerStepTimeLabel.bottomAnchor, bottom: nil, leading: headerStepTimeLabel.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        
        headerNextStepLabel.leadingAnchor.constraint(equalTo: headerStepTitleLabel.leadingAnchor).isActive = true
        headerNextStepLabel.topAnchor.constraint(equalTo: headerStepTitleLabel.bottomAnchor, constant: 10.0).isActive = true
        
        headerNextStepTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        headerNextStepTimeLabel.topAnchor.constraint(equalTo: headerNextStepLabel.bottomAnchor, constant: 10).isActive = true
        
        headerNextStepTitleLabel.leadingAnchor.constraint(equalTo: headerNextStepTimeLabel.leadingAnchor).isActive = true
        headerNextStepTitleLabel.topAnchor.constraint(equalTo: headerNextStepTimeLabel.bottomAnchor, constant: 0.0).isActive = true
        
        saveButton.trailingAnchor.constraint(equalTo: innerPaddedView.trailingAnchor, constant: -10.0).isActive = true
        saveButton.topAnchor.constraint(equalTo: innerPaddedView.topAnchor, constant: 10.0).isActive = true
        saveButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.18).isActive = true
    }
    
    private func setupAutoLayout() {        
        /// Height for header
        switch UIDevice.current.screenType.rawValue {
        case UIDevice.ScreenType.iPhones_6Plus_6sPlus_7Plus_8Plus.rawValue, UIDevice.ScreenType.iPhones_6_6s_7_8.rawValue:
            heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2.8).isActive = true
        case UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue:
            heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2.3).isActive = true
        case UIDevice.ScreenType.iPhoneXSMax.rawValue, UIDevice.ScreenType.iPhoneX_iPhoneXS.rawValue, UIDevice.ScreenType.iPhoneXR.rawValue:
            heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3.3).isActive = true
        default:
            heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3.3).isActive = true
        }
        
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
    }
    

    func updateHeaderTitleLabel(title: String) {
        guard let theme = theme else {
            return
        }
        headerTitleLabel.attributedText = NSAttributedString(string: title, attributes: theme.currentTheme.tableView.recipeHeaderRecipe)
    }
    
    func updateHeaderNextStepTimeLabel(time: String) {
        guard let theme = theme else {
            return
        }
        headerNextStepTimeLabel.attributedText = NSAttributedString(string: time, attributes: theme.currentTheme.tableView.recipeHeaderTime)
    }
    
    func updateHeaderNextStepTitleLabel(title: String) {
        guard let theme = theme else {
            return
        }
        headerNextStepTitleLabel.attributedText = NSAttributedString(string: title, attributes: theme.currentTheme.tableView.recipeHeaderStepName)
    }
    
    func updateHeaderStepTimeLabel(time: String) {
        guard let theme = theme else {
            return
        }
        headerStepTimeLabel.attributedText = NSAttributedString(string: time, attributes: theme.currentTheme.tableView.recipeHeaderTime)
    }
    
    func updateHeaderStepTitleLabel(title: String) {
        guard let theme = theme else {
            return
        }
        headerStepTitleLabel.attributedText = NSAttributedString(string: title, attributes: theme.currentTheme.tableView.recipeHeaderStepName)
    }
    
    func saveButtonEnable() {
        saveButton.alpha = 1.0
        saveButton.isEnabled = true
    }
    
    func saveButtonDisable() {
        saveButton.alpha = 0.0
        saveButton.isEnabled = false
    }
    
    @objc func handleMinusTime() {
        if let delegate = delegate {
            delegate.handleMinusTime()
        }
    }
    
    @objc func handleAdditionalTime() {
        if let delegate = delegate {
            delegate.handleAdditionalTime()
        }
    }
    
    @objc func handleResetStepTime() {
        if let delegate = delegate {
            delegate.handleResetStepTime()
        }
    }
    
    @objc func handleSave() {
        if let delegate = delegate {
            delegate.handleSave()
        }
    }
    
    @objc func handleFullScreen() {
        if let delegate = delegate {
            delegate.handleLargeDisplay()
        }
    }
}
