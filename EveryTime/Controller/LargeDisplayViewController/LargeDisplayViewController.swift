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
    
    lazy var mainView: LargeDisplayMainView = {
       let view = LargeDisplayMainView(delegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func prepareViewController() {
        super.prepareViewController()
        view.backgroundColor = UIColor.white
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func prepareView() {
        super.prepareView()
        view.addSubview(mainView)
        mainView.anchorView(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
    }
    
    func handleClose() {

        self.dismiss(animated: true, completion: nil)
    }
    
    func updateViewRecipeLabel(recipeName: String) {
//        mainView.updateRecipeLabel(currRecipe: recipeName)
        mainView.updateRecipeLabel(currRecipe: recipeName)
    }
    
    func updateViewTimeLabel(timeRemaining: String) {
        mainView.updateTimeLabel(currTime: timeRemaining)
    }
    
    func updateViewStepLabel(stepName: String) {
        mainView.updateStepLabel(currStep: stepName)
    }
}
