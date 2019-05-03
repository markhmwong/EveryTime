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
    
    private lazy var innerPaddedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 8.0
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

    private lazy var additionalTimeButton: StandardButton = {
        let button = StandardButton(title: "+15")
        button.addTarget(self, action: #selector(handleAdditionalTime), for: .touchUpInside)
        return button
    }()
    
    private lazy var subtractTimeButton: StandardButton = {
        let button = StandardButton(title: "-15")
        button.addTarget(self, action: #selector(handleMinusTime), for: .touchUpInside)
        return button
    }()
    
    private lazy var resetTimeButton: StandardButton = {
        let button = StandardButton(title: "Reset")
        button.addTarget(self, action: #selector(handleResetStepTime), for: .touchUpInside)
        return button
    }()
    
    private lazy var fullScreenButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "FullScreen.png"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var saveButton: StandardButton = {
        let button = StandardButton(title:"Save")
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0.0
        button.isEnabled = false
        return button
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.clear
        addSubview(innerPaddedView)

        fullScreenButton.addTarget(self, action: #selector(handleFullScreen), for: .touchUpInside)
        innerPaddedView.addSubview(fullScreenButton)
        
        headerTitleLabel.attributedText = NSAttributedString(string: "No name", attributes: Theme.Font.Recipe.HeaderTableView)
        innerPaddedView.addSubview(headerTitleLabel)
        innerPaddedView.addSubview(headerStepTimeLabel)
        innerPaddedView.addSubview(headerStepTitleLabel)
        innerPaddedView.addSubview(headerNextStepTitleLabel)
        innerPaddedView.addSubview(headerNextStepTimeLabel)
        headerNextStepLabel.attributedText = NSAttributedString(string: "Next Step", attributes: Theme.Font.Recipe.HeaderTableViewContentSubTitle)
        innerPaddedView.addSubview(headerNextStepLabel)
        
        additionalTimeButton.isEnabled = false
        additionalTimeButton.alpha = 0.4
        resetTimeButton.isEnabled = false
        resetTimeButton.alpha = 0.4
        subtractTimeButton.isEnabled = false
        subtractTimeButton.alpha = 0.4
        
        innerPaddedView.addSubview(saveButton)
        innerPaddedView.addSubview(additionalTimeButton)
        innerPaddedView.addSubview(subtractTimeButton)
        innerPaddedView.addSubview(resetTimeButton)
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
        
        let screenSize = UIScreen.main.bounds.size
        additionalTimeButton.trailingAnchor.constraint(equalTo: innerPaddedView.leadingAnchor, constant: (screenSize.width / 8) * 2).isActive = true
        additionalTimeButton.bottomAnchor.constraint(equalTo: innerPaddedView.bottomAnchor, constant: -10).isActive = true
        additionalTimeButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.18).isActive = true

        resetTimeButton.centerXAnchor.constraint(equalTo: innerPaddedView.centerXAnchor, constant: 0).isActive = true
        resetTimeButton.bottomAnchor.constraint(equalTo: innerPaddedView.bottomAnchor, constant: -10).isActive = true
        resetTimeButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.18).isActive = true

        subtractTimeButton.leadingAnchor.constraint(equalTo: innerPaddedView.trailingAnchor, constant: -(screenSize.width / 8) * 2).isActive = true
        subtractTimeButton.bottomAnchor.constraint(equalTo: innerPaddedView.bottomAnchor, constant: -10.0).isActive = true
        subtractTimeButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.18).isActive = true
        
        saveButton.trailingAnchor.constraint(equalTo: innerPaddedView.trailingAnchor, constant: -10.0).isActive = true
        saveButton.topAnchor.constraint(equalTo: innerPaddedView.topAnchor, constant: 10.0).isActive = true
        saveButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.18).isActive = true

        fullScreenButton.topAnchor.constraint(equalTo: innerPaddedView.topAnchor, constant: 10.0).isActive = true
        fullScreenButton.trailingAnchor.constraint(equalTo: innerPaddedView.trailingAnchor, constant: -10.0).isActive = true
        fullScreenButton.widthAnchor.constraint(equalToConstant: 15.0).isActive = true
        fullScreenButton.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
    }
    

    func updateHeaderTitleLabel(title: String) {
        headerTitleLabel.attributedText = NSAttributedString(string: title, attributes: Theme.Font.Recipe.HeaderTableView)
    }
    
    func updateHeaderNextStepTimeLabel(time: String) {
        headerNextStepTimeLabel.attributedText = NSAttributedString(string: time, attributes: Theme.Font.Recipe.HeaderTableViewContentTime)
    }
    
    func updateHeaderNextStepTitleLabel(title: String) {
        headerNextStepTitleLabel.attributedText = NSAttributedString(string: title, attributes: Theme.Font.Recipe.HeaderTableViewContentTitle)
    }
    
    func updateHeaderStepTimeLabel(time: String) {
        headerStepTimeLabel.attributedText = NSAttributedString(string: time, attributes: Theme.Font.Recipe.HeaderTableViewContentTime)
    }
    
    func updateHeaderStepTitleLabel(title: String) {
        headerStepTitleLabel.attributedText = NSAttributedString(string: title, attributes: Theme.Font.Recipe.HeaderTableViewContentTitle)
    }
    
    func enableStepOptions() {
        additionalTimeButton.isEnabled = true
        resetTimeButton.isEnabled = true
        subtractTimeButton.isEnabled = true
        additionalTimeButton.alpha = 1.0
        resetTimeButton.alpha = 1.0
        subtractTimeButton.alpha = 1.0
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
