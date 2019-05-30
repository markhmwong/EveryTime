//
//  LargeDisplayViewController.swift
//  EveryTime
//
//  Created by Mark Wong on 3/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class LargeDisplayViewController: ViewControllerBase {
    
    var viewModel: LargeDisplayViewModel?
    
    weak var delegate: RecipeViewControllerWithTableView?
    
    lazy var mainView: LargeDisplayMainView = {
        let view = LargeDisplayMainView(delegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(delegate: RecipeViewControllerWithTableView, viewModel: LargeDisplayViewModel? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.viewModel = viewModel
        self.viewModel?.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotateDeviceRight() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .landscapeRight
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()

        UIView.setAnimationsEnabled(true) // while rotating device it will perform the rotation animation
    }
    
    func rotateDeviceLeft() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .landscapeLeft
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()

        UIView.setAnimationsEnabled(true) // while rotating device it will perform the rotation animation
    }
    
    func rotateDevicePortrait() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .portrait
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()

        UIView.setAnimationsEnabled(true) // while rotating device it will perform the rotation animation
    }
    
    @objc func didRotateDevice(notification: NSNotification) {
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
            rotateDeviceLeft()

        } else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            rotateDeviceLeft()

        } else {
            rotateDevicePortrait()
        }

    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func prepareViewController() {
        super.prepareViewController()
        guard let vm = viewModel else {
            return
        }
        view.backgroundColor = vm.theme?.currentTheme.generalBackgroundColour
    }
    
    override func prepareView() {
        super.prepareView()
        view.addSubview(mainView)
    }

    override func prepareAutoLayout() {
        super.prepareAutoLayout()
        mainView.anchorView(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)

    }
    
    var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didRotateDevice), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func handleClose() {
        viewModel = nil
        delegate?.dismissFullScreenDisplay()
        delegate = nil
    }
    
    func updateViewRecipeLabel(recipeName: String) {
        mainView.updateRecipeLabel(currRecipe: recipeName)
    }
    
    func updateViewNextStepLabel(nextStepName: String) {
        mainView.updateNextStepLabel(nextStep: nextStepName)
    }
    
    func updateViewTimeLabel(timeRemaining: String) {
        mainView.updateTimeLabel(currTime: timeRemaining)
    }
    
    func updateViewStepLabel(stepName: String) {
        mainView.updateStepLabel(currStep: stepName)
    }
    
    func updateViewStepsCompleteLabel(stepComplete: String) {
        mainView.updateViewStepsCompleteLabel(stepComplete: stepComplete)
    }
    
    func updateViewControls(pauseState: Bool) {
        mainView.updateControls(pauseState: pauseState)
    }
    
    func triggerNextStep() throws {
        guard let recipe = delegate?.recipe else {
            return
        }
        
        let time = -recipe.currStepTimeRemaining
        let priority = recipe.currStepPriority
        guard let stepSet = recipe.step else {
            return
        }
        
        if (priority < stepSet.count) {
            do {
                try recipe.adjustTime(by: time, selectedStep: Int(priority))
            } catch StepOptionsError.StepAlreadyComplete(let _) {
//                print(message)
                ()//show alert box
            } catch {
                ()
            }
        } else {
            throw ControlsError.LimitReached(message: "Upper Bound Reached")
        }

    }
    
    func triggerPrevStep() throws {
        
        guard let recipe = delegate?.recipe else {
            return
        }
        
        let priority = recipe.currStepPriority
        if (priority > 0) {
            recipe.resetEntireRecipeTo(toStep: Int(priority - 1))
        } else {
            throw ControlsError.LimitReached(message:"Lower Bound Reached")
        }
        
    }
    
    func handlePauseButton() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        
        guard let vm = viewModel else {
            return
        }
        
        //update button text
        guard let delegate = delegate else {
            return
        }
        mainView.updateViewPauseButton(pausedState:  !delegate.recipe.isPaused)
        mainView.updateControls(pauseState: !delegate.recipe.isPaused)
        delegate.handlePauseRecipe()
    }
    
    deinit {
//        print("LargeDisplayViewController - deinit")
    }
}

