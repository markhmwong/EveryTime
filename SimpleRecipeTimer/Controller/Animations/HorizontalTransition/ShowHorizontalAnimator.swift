//
//  HorizontalAnimator.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 20/1/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class ShowHorizontalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else { return }
        
        let endFrame = toVC.view.frame
        let startFrame = CGRect(x: endFrame.size.width, y: 0, width: endFrame.size.width, height: endFrame.size.height)
        toVC.view.frame = startFrame
        
        transitionContext.containerView.addSubview(toVC.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .allowUserInteraction,
            animations: {
                toVC.view.frame = endFrame
        },
            completion: {
                (finished) in
                transitionContext.completeTransition(finished) })
    }
}


