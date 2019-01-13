//
//  StepsViewController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 5/12/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//  Houses one step

import UIKit

class StepsViewController: UIViewController, TimerProtocol {
    
    var recipeViewControllerDelegate: RecipeViewController?
    var timer: Timer?
    fileprivate var step: StepEntity?
    fileprivate var timeLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.backgroundColor = UIColor.white
        return label
    }()
    fileprivate var pauseButton = UIButton()
    
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
        self.view.backgroundColor = UIColor.white

        guard let s = step else {
            return
        }
        
        self.prepareLabels()
        self.updatePauseButton(s: s)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.stopTimer()
        if let s = step {
            if (!s.isPausedPrimary) {
                s.updateTotalElapsedTime()
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
    
    func prepareLabels() {
        let safeGuide = self.view.safeAreaLayoutGuide

        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: safeGuide.topAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: safeGuide.widthAnchor).isActive = true
    
        pauseButton.setTitle("pause", for: .normal)
        pauseButton.backgroundColor = UIColor.yellow
        pauseButton.setTitleColor(UIColor.blue, for: .normal)
    
        pauseButton.addTarget(self, action: #selector(pauseHandler), for: .touchUpInside)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pauseButton)
        pauseButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor).isActive = true
        pauseButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pauseButton.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    //MARK: Button Handlers
    @objc func pauseHandler() {
        if let s = step {
            if (!s.isPausedPrimary) {
                self.stopTimer()
                s.updateTotalElapsedTime()
                pauseButton.setTitle("unpause", for: .normal)
            } else {
                self.startTimer()
                s.updateExpiry()
                pauseButton.setTitle("pause", for: .normal)
            }
            s.updatePauseState()
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
            timeLabel.text = s.timeRemaining()
        }
    }
}
