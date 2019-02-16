//
//  StepsViewController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 5/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//  Houses one step

import UIKit

class StepsViewController: ViewControllerBase, TimerProtocol {
    var recipeViewControllerDelegate: RecipeViewController?
    var transitionDelegate = OverlayTransitionDelegate()
    var dismissInteractor: OverlayInteractor!
    var horizontalTransitionDelegate = HorizontalTransitionDelegate()
    var horizontalTransitionInteractor: HorizontalTransitionInteractor? = nil
    
    fileprivate var timer: Timer?
    var step: StepEntity! {
        didSet {
            print("step enttiy did set")
            guard let s = step else {
                print("Step was not initialised")
                return
            }
            
            nameLabel.attributedText = NSAttributedString(string: s.stepName!, attributes: Theme.Font.Step.NameAttribute)
        }
    }

    fileprivate var pauseButton: UIButton = {
        let button = UIButton()
        button.setTitle("pause", for: .normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(Theme.Font.Color.TextColour, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    fileprivate lazy var navView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    fileprivate var timeLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "", attributes: Theme.Font.Step.NameAttribute)
        
        return label
    }()
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "unknown", attributes: Theme.Font.Step.NameAttribute)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    fileprivate lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Theme.Font.Color.TextColour, for: .normal)
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    init(stepEntity: StepEntity, viewControllerDelegate: RecipeViewController) {
        super.init(nibName: nil, bundle: nil)
        
        self.recipeViewControllerDelegate = viewControllerDelegate
        /*
         https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Properties.html
            The willSet and didSet observers of superclass properties are called when a property is set in a subclass initializer, after the superclass initializer has been called. They are not called while a class is setting its own properties, before the superclass initializer has been called.
         */
        defer {
            self.step = stepEntity
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViewController()
        prepareView()
        prepareAutoLayout()
        guard let s = step else {
            return
        }
        
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
    
    override func prepareViewController() {
        self.view.backgroundColor = Theme.Background.Color.GeneralBackgroundColor
    }
    override func prepareView() {
        navView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(navView)
        navView.addSubview(dismissButton)
        self.view.addSubview(nameLabel)
        self.view.addSubview(timeLabel)
        self.view.addSubview(pauseButton)
        pauseButton.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
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
    
    override func prepareAutoLayout() {
        let safeLayoutGuide = self.view.safeAreaLayoutGuide
        
        navView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor).isActive = true
        navView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        navView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        navView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        
        dismissButton.centerYAnchor.constraint(equalTo: navView.centerYAnchor).isActive = true
        dismissButton.leadingAnchor.constraint(equalTo: navView.leadingAnchor, constant: 10).isActive = true
        
        nameLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -150).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: safeLayoutGuide.widthAnchor).isActive = true
        
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
        self.stopTimer()
        rvc.dismiss(animated: true) {
            rvc.startTimer()
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
        guard let s = step else {
            timeLabel.attributedText = NSAttributedString(string: "nil", attributes: Theme.Font.Step.TimeAttribute)
            return
        }
        timeLabel.attributedText = NSAttributedString(string: s.timeRemainingToString(), attributes: Theme.Font.Step.TimeAttribute)
    }
}
