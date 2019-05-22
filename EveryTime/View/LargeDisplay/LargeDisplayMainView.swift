//
//  LargeDisplayMainView.swift
//  EveryTime
//
//  Created by Mark Wong on 4/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class LargeDisplayMainView: UIView {
    
    weak var delegate: LargeDisplayViewController?
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "close", attributes: delegate?.viewModel?.theme?.currentTheme.font.recipeName), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0.01, left: 0.0, bottom: 0.0, right: -0.01)
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Time Loading..", attributes: delegate?.viewModel?.theme?.currentTheme.font.recipeName)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var recipeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Current Recipe", attributes: delegate?.viewModel?.theme?.currentTheme.font.recipeName)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stepLabel: MarqueeLabel = {
        let label = MarqueeLabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50.0), rate: 30.0, fadeLength: 10.0)
        label.attributedText = NSAttributedString(string: "Unknown step", attributes: delegate?.viewModel?.theme?.currentTheme.font.recipeName)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    lazy var stepsCompleteLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "0/0", attributes: delegate?.viewModel?.theme?.currentTheme.font.recipeName)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    lazy var upNextStepLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Up Next", attributes: delegate?.viewModel?.theme?.currentTheme.font.recipeName)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    lazy var upNextStepNameLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.attributedText = NSAttributedString(string: "Next Step", attributes: delegate?.viewModel?.theme?.currentTheme.font.recipeName)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.type = .continuous
        label.animationCurve = .easeInOut
        label.speed = MarqueeLabel.SpeedLimit.rate(30.0)
        label.fadeLength = 10.0
        return label
    }()
    
    lazy var nextStepButton: StandardButton = {
        let button = StandardButton(title: "Next", theme: delegate?.viewModel?.theme)
        button.addTarget(self, action: #selector(handleNextStep), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var prevStepButton: StandardButton = {
        let button = StandardButton(title: "Prev", theme: delegate?.viewModel?.theme)
        button.addTarget(self, action: #selector(handlePrevStep), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var pauseButton: StandardButton = {
        let button = StandardButton(title: "Start", theme: delegate?.viewModel?.theme)
        button.addTarget(self, action: #selector(handlePauseButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(delegate: LargeDisplayViewController?) {
        self.init(frame: .zero)
        self.delegate = delegate
        self.setupView()
        self.setupConstraints()
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
        addSubview(closeButton)
        stepLabel.attributedText = NSAttributedString(string: "Step Loading..", attributes: Theme.Font.LargeDisplay.LargeStepLabel)
        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        stepLabel.type = .continuous
        stepLabel.animationCurve = .easeInOut
        addSubview(stepLabel)
        addSubview(stepsCompleteLabel)
        addSubview(upNextStepLabel)
        addSubview(upNextStepNameLabel)
        addSubview(nextStepButton)
        addSubview(prevStepButton)
        addSubview(pauseButton)
        upNextStepNameLabel.restartLabel()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    
    func setupConstraints() {
        let topConstraint = !appDelegate.hasTopNotch ? topAnchor : nil
        
        recipeLabel.anchorView(top: topConstraint, bottom: nil, leading: leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 40, left: 10, bottom: 0, right: -10), size: .zero)
        timeLabel.anchorView(top: nil, bottom: centerYAnchor, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: .zero, size: .zero)
        stepLabel.anchorView(top: nil, bottom: timeLabel.topAnchor, leading: recipeLabel.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: UIScreen.main.bounds.width - 20.0, height: 40.0))
        closeButton.anchorView(top: topAnchor, bottom: nil, leading: nil, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: 80, height: 0))
        upNextStepLabel.anchorView(top: nil, bottom: upNextStepNameLabel.topAnchor, leading: recipeLabel.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        upNextStepNameLabel.anchorView(top: nil, bottom: bottomAnchor, leading: recipeLabel.leadingAnchor, trailing: recipeLabel.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 40.0))
        stepsCompleteLabel.anchorView(top: recipeLabel.bottomAnchor, bottom: nil, leading: recipeLabel.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        
        let screenHeight = UIScreen.main.bounds.height
        
        nextStepButton.anchorView(top: nil, bottom: bottomAnchor, leading: pauseButton.trailingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .init(top: 0.0, left: 10.0, bottom: -(screenHeight / 4), right: 0.0), size: .zero)
        nextStepButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.22).isActive = true

        prevStepButton.anchorView(top: nil, bottom: bottomAnchor, leading: nil, trailing: pauseButton.leadingAnchor, centerY: nil, centerX: nil, padding: .init(top: 0.0, left: -10.0, bottom: -(screenHeight / 4), right: -10.0), size: .zero)
        prevStepButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.22).isActive = true
        
        pauseButton.anchorView(top: nil, bottom: bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: .init(top: 0.0, left: -10.0, bottom: -(screenHeight / 4), right: -10.0), size: .zero)
        pauseButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.30).isActive = true

    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        if (appDelegate.hasTopNotch) {
            let safeAreaInsets = self.safeAreaInsets
            recipeLabel.topAnchor.constraint(equalTo: topAnchor, constant: safeAreaInsets.top).isActive = true //keeps the bar in position as the view performs the transition
        }
    }
    
    /// The completionHandler is used for UITesting with the main thread. So we are aware of when the main thread has completed executing.
    func updateRecipeLabel(currRecipe: String = "Unknown Recipe",_ completionHandler: (() -> ())? = nil) {
        guard let vm = delegate?.viewModel else {
            return
        }
        
        DispatchQueue.main.async {
            self.recipeLabel.attributedText = NSAttributedString(string: currRecipe, attributes: vm.theme?.currentTheme.font.recipeName)
            completionHandler?()
        }
    }
    
    func updateTimeLabel(currTime: String = "Unknown Time", _ completionHandler: (() -> ())? = nil) {
        guard let vm = delegate?.viewModel else {
            return
        }
        DispatchQueue.main.async {
            self.timeLabel.attributedText = NSAttributedString(string: currTime, attributes: vm.theme?.currentTheme.font.stepTime)
        }
    }
    
    func updateNextStepLabel(nextStep: String = "Unknown Next Step", _ completionHandler: (() -> ())? = nil) {
        guard let vm = delegate?.viewModel else {
            return
        }
        DispatchQueue.main.async {
            self.upNextStepNameLabel.attributedText = NSAttributedString(string: nextStep, attributes: vm.theme?.currentTheme.font.stepName)
        }
    }
    
    func updateStepLabel(currStep: String = "Unknown Step", _ completionHandler: (() -> ())? = nil) {
        guard let vm = delegate?.viewModel else {
            return
        }
        DispatchQueue.main.async {
            self.stepLabel.attributedText = NSAttributedString(string: currStep, attributes: vm.theme?.currentTheme.font.stepName)
        }
    }
    
    /// Number of step complete
    func updateViewStepsCompleteLabel(stepComplete: String = "Unknown Step", _ completionHandler: (() -> ())? = nil) {
        guard let vm = delegate?.viewModel else {
            return
        }
        DispatchQueue.main.async {
            self.stepsCompleteLabel.attributedText = NSAttributedString(string: stepComplete, attributes: vm.theme?.currentTheme.font.stepName)
        }
    }
    
    func updateViewPauseButton(pausedState: Bool) {
        if (pausedState) {
            pauseButton.updateButtonTitle(with: "Start")
        } else {
            pauseButton.updateButtonTitle(with: "Pause")

        }
    }
    
    func updateControls(pauseState: Bool) {
        nextStepButton.isEnabled = pauseState ? false : true
        prevStepButton.isEnabled = pauseState ? false : true
        DispatchQueue.main.async {
            self.nextStepButton.alpha = pauseState ? 0.5 : 1.0
            self.prevStepButton.alpha = pauseState ? 0.5 : 1.0
        }
    }
    
    @objc func handleNextStep() {
        guard let delegate = delegate else {
            return
        }
        do {
            try delegate.triggerNextStep()
        } catch ControlsError.LimitReached(let message) {
            print("\(message)")
        } catch {
            print("control error")
        }
    }
    
    @objc func handlePrevStep() {
        guard let delegate = delegate else {
            return
        }
        do {
            try delegate.triggerPrevStep()
        } catch ControlsError.LimitReached(let message) {
//            print("\(message)")
        } catch {
            print("control error")
        }
    }
    
    @objc func handlePauseButton() {
        
        guard let delegate = delegate else {
            return
        }
        
        delegate.handlePauseButton()
        
        print("pause Button")
    }
    
    
}
