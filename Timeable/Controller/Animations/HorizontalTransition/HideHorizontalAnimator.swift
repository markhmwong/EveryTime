//
//  HideHorizontalAnimator.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 20/1/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class HideHorizontalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
            else { return }
        
        let startFrame = fromVC.view.frame
        let endFrame = CGRect(x: startFrame.size.width, y: 0, width: startFrame.size.width, height: startFrame.size.height)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0.0,
                       options: .curveEaseIn,
                       animations: {
                        fromVC.view.frame = endFrame
        },
                       completion: {
                        _ in
                        if transitionContext.transitionWasCancelled {
                            transitionContext.completeTransition(false)
                        } else {
                            transitionContext.completeTransition(true)
                        }
        })
    }
}
