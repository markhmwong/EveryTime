//
//  StepsViewController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 5/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//  Houses one step

import UIKit

class StepsViewController: UIViewController, TimerProtocol {
    
    fileprivate var timer: Timer?
    fileprivate var step: StepEntity?
    fileprivate var timeLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = UIColor.white
        return label
    }()
    fileprivate var pauseButton = UIButton()
    var recipeViewControllerDelegate: RecipeViewController?
    var transitionDelegate = OverlayTransitionDelegate()
    var dismissInteractor: OverlayInteractor!
    var horizontalTransitionDelegate = HorizontalTransitionDelegate()
    var horizontalTransitionInteractor: HorizontalTransitionInteractor? = nil
    
    lazy var navView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        return view
    }()
    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Theme.Font.Color.TextColour, for: .normal)
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    lazy var nameLabel: UILabel? = nil
    
    init(stepModel: StepEntity) {
        super.init(nibName: nil, bundle: nil)
        self.step = stepModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor

        guard let s = step else {
            return
        }
        
        self.prepareLabels(s: s)
        self.updatePauseButton(s: s)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.stopTimer()
        if let s = step {
            if (!s.isPausedPrimary) {
                s.updateTotalTimeRemaining()
            }
        }
    }
    
    // update pause button text
    func updatePauseButton(s: StepEntity) {
        timeLabel.text = s.timeRemainingPausedState()

        if (s.isPausedPrimary) {
            pauseButton.setTitle("unpause", for: .normal)
            self.stopTimer()
        } else {
            s.updateExpiry()
            self.startTimer()
        }
    }
    
    func prepareLabels(s: StepEntity) {
        let safeLayoutGuide = self.view.safeAreaLayoutGuide
        navView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(navView)
        navView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor).isActive = true
        navView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        navView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        navView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        navView.addSubview(dismissButton)
        dismissButton.centerYAnchor.constraint(equalTo: navView.centerYAnchor).isActive = true
        dismissButton.leadingAnchor.constraint(equalTo: navView.leadingAnchor, constant: 10).isActive = true
        
        nameLabel = UILabel()
        nameLabel?.attributedText = NSAttributedString(string: s.stepName!, attributes: Theme.Font.Step.NameAttribute)
        self.view.addSubview(nameLabel!)
        nameLabel?.translatesAutoresizingMaskIntoConstraints = false
        nameLabel?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -150).isActive = true
        nameLabel?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        
        timeLabel.attributedText = NSAttributedString(string: "", attributes: Theme.Font.Step.NameAttribute)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: nameLabel!.bottomAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: safeLayoutGuide.widthAnchor).isActive = true
    
        pauseButton.setTitle("pause", for: .normal)
        pauseButton.backgroundColor = UIColor.yellow
        pauseButton.setTitleColor(UIColor.blue, for: .normal)
    
        pauseButton.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pauseButton)
        pauseButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor).isActive = true
        pauseButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pauseButton.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    //MARK: Button Handlers
    @objc func handlePause() {
        if let s = step {
            if (!s.isPausedPrimary) {
                self.stopTimer()
                s.updateTotalTimeRemaining()
                pauseButton.setTitle("unpause", for: .normal)
            } else {
                self.startTimer()
                s.updateExpiry()
                pauseButton.setTitle("pause", for: .normal)
            }
            s.updatePauseState()
        }
    }
    
    @objc func handleDismiss() {
        guard let rvc = recipeViewControllerDelegate else {
            return
        }
        rvc.dismiss(animated: true) {
            self.stopTimer()
        }
    }
    
    //MARK: - Timer Protocol
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }

    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func update() {
        if let s = step {
            timeLabel.attributedText = NSAttributedString(string: s.timeRemainingToString(), attributes: Theme.Font.Step.TimeAttribute)
        }
    }
}
