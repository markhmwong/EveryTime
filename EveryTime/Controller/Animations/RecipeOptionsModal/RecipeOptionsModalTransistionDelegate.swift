//
//  RecipeOptionsModalTransistionDelegate.swift
//  EveryTime
//
//  Created by Mark Wong on 27/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class RecipeOptionsModalTransistionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var dismissInteractor: OverlayInteractor!
    
    convenience init(interactor: OverlayInteractor) {
        self.init()
        self.dismissInteractor = interactor
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return RecipeModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = RecipeModalAnimatedTransitioning(isPresenting: true)
        animator.initialY = presenting.view.bounds.height
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = DismissOverlayAnimator(isPresenting: false)
        animator.initialY = dismissed.view.bounds.height
        return animator
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return dismissInteractor.hasStarted ? dismissInteractor : nil
    }
    
}
