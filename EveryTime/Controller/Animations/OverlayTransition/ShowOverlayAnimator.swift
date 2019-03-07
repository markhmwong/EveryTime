//
//  ShowOverlayAnimator.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 18/1/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class ShowOverlayAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var isPresenting: Bool = true
    var initialY: CGFloat = 0
    convenience init(isPresenting: Bool = true) {
        self.init()
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.viewController(forKey: .from)?.view else {
            return
        }
        guard let toView = transitionContext.viewController(forKey: .to)?.view else {
            return
        }
        
        let screenSize = UIScreen.main.bounds.size
        var center = toView.center //use center for view translations in the x, y directions. As scaling and rotation factors won't affect the center point when they are applied to the view's transform.
        if isPresenting {
            toView.center.y = toView.center.y + (screenSize.height / 2) + initialY
            transitionContext.containerView.addSubview(toView)
        } else {
            center.y = toView.bounds.size.height + fromView.bounds.size.height
        }
        let originalTransform = fromView.transform
        let transformed = originalTransform.translatedBy(x: 0, y: 40).scaledBy(x: 0.97, y: 0.97)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: [.preferredFramesPerSecond60, .curveEaseIn], animations: {
            toView.center = center
            fromView.transform = transformed
        }) { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
