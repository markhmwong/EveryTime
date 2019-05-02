//
//  RecipeModalPresentationController.swift
//  EveryTime
//
//  Created by Mark Wong on 27/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class RecipeModalPresentationController: UIPresentationController {
    let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        return view
    }()
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let offset: CGFloat = UIScreen.main.bounds.height / 3.0
        var size = containerView!.bounds.size
        size.height = size.height - offset
        size.width = size.width - 20.0
        
        let offSetFromBottom: CGFloat = 20.0
        
        return CGRect(origin: CGPoint(x: 10.0, y: offset - offSetFromBottom), size: size)
    }
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds
        dimmingView.alpha = 0.0
        containerView!.insertSubview(dimmingView, at: 0)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        }) { _ in
            
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if (completed) {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        dimmingView.frame = containerView!.bounds
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}
