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
    
    var delegate: RecipeViewControllerWithTableView?
    
    init(delegate: RecipeViewControllerWithTableView, viewModel: LargeDisplayViewModel? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var mainView: LargeDisplayMainView = {
       let view = LargeDisplayMainView(delegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .landscapeLeft
//    }
    
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
            rotateDeviceRight()

        } else {
            rotateDevicePortrait()
        }

    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func prepareViewController() {
        super.prepareViewController()
        view.backgroundColor = UIColor.white
//        let value = UIInterfaceOrientation.landscapeLeft.rawValue
//        UIDevice.current.setValue(value, forKey: "orientation")
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
    
    /// Executes 10 April 2019
    deinit {
        print("LargeDisplayViewController - deinit")
    }
}
