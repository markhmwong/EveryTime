//
//  LargeDisplayMainView.swift
//  EveryTime
//
//  Created by Mark Wong on 4/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class LargeDisplayMainView: UIView {
    
    var delegate: LargeDisplayViewController?
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("close", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "00h 00m 00s", attributes: Theme.Font.LargeDisplay.LargeTimerLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stepLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Current Step", attributes: Theme.Font.LargeDisplay.LargeStepLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var recipeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Current Recipe", attributes: Theme.Font.LargeDisplay.LargeRecipeTitleLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var marqueeLabel: BasicMarqueeLabel = {
        let label = BasicMarqueeLabel()
        label.attributedText = NSAttributedString(string: "A let keyword mark's a variable to employ a characteristic", attributes: Theme.Font.LargeDisplay.LargeStepLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupConstraints()
    }
    
    convenience init(delegate: LargeDisplayViewController?) {
        self.init(frame: .zero)
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleClose() {
        guard let d = delegate else {
            return
        }
        d.handleClose()
    }
    
    func setupView() {
        addSubview(timeLabel)
        addSubview(recipeLabel)
        addSubview(stepLabel)
        addSubview(marqueeLabel)
        addSubview(closeButton)
    }
    
    func setupConstraints() {
        let screenSize = UIScreen.main.bounds
        let topConstraint = !appDelegate.hasTopNotch ? topAnchor : nil
        
        recipeLabel.anchorView(top: topConstraint, bottom: nil, leading: timeLabel.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
        timeLabel.anchorView(top: topAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: screenSize.height / 3, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
        stepLabel.anchorView(top: nil, bottom: timeLabel.topAnchor, leading: timeLabel.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        closeButton.anchorView(top: nil, bottom: bottomAnchor, leading: nil, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: -40, right: -10), size: .zero)
        marqueeLabel.anchorView(top: timeLabel.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: .zero)
    }
    
    
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        if (appDelegate.hasTopNotch) {
            let safeAreaInsets = self.safeAreaInsets
            recipeLabel.topAnchor.constraint(equalTo: topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
        }
    }
    
    func updateRecipeLabel(currRecipe: String = "Unknown Recipe",_ completionHandler: (() -> ())? = nil) {
        DispatchQueue.main.async {
            self.recipeLabel.attributedText = NSAttributedString(string: currRecipe, attributes: Theme.Font.LargeDisplay.LargeRecipeTitleLabel)
            completionHandler?()
        }
    }
    
    func updateTimeLabel(currTime: String = "Unknown Time", _ completionHandler: (() -> ())? = nil) {
        DispatchQueue.main.async {
            self.timeLabel.attributedText = NSAttributedString(string: currTime, attributes: Theme.Font.LargeDisplay.LargeTimerLabel)
        }
    }
    
    func updateStepLabel(currStep: String = "Unknown Step", _ completionHandler: (() -> ())? = nil) {
        DispatchQueue.main.async {
            self.stepLabel.attributedText = NSAttributedString(string: currStep, attributes: Theme.Font.LargeDisplay.LargeStepLabel)
        }
    }
}
