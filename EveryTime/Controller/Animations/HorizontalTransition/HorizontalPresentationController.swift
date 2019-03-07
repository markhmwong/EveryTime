//
//  HorizontalPresentationController.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 1/2/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//
import UIKit

class HorizontalPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        let size = containerView!.bounds.size
        return CGRect(origin: CGPoint(x: 0, y: 0), size: size)
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func presentationTransitionWillBegin() {

    }
    
    override func dismissalTransitionWillBegin() {

    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {

    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {

    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

}
