//
//  HorizontalTransitionDelegate.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 20/1/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class HorizontalTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var dismissInteractor: HorizontalTransitionInteractor!
    convenience init(interactor: HorizontalTransitionInteractor) {
        self.init()
        self.dismissInteractor = interactor
    }
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ShowHorizontalAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HideHorizontalAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let dismissalInteractionController = dismissInteractor else { return nil }
        
        if dismissalInteractionController.enabled {
            return dismissalInteractionController
        } else {
            return nil
        }
    }
}
