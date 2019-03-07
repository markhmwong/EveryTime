//
//  InteractiveTransition.swift
//  InteractiveViewControllerTransition
//
//  Created by Mark Wong on 17/1/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class OverlayInteractor: UIPercentDrivenInteractiveTransition {
    
    var viewController: UIViewController?
    var presentViewController: UIViewController?
    var pan: UIPanGestureRecognizer!
    var shouldComplete = false
    var lastProgress: CGFloat?

    var hasStarted = false
    var shouldFinish = false
    
    
    func attachToViewController(viewController: UIViewController, withView view: UIView, presentViewController: UIViewController?) {
        self.viewController = viewController
        self.presentViewController = presentViewController
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        view.addGestureRecognizer(pan)
    }
    
    @objc func onPan(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: pan.view?.superview)
        let percentThreshold: CGFloat = 0.25

        guard let vc = viewController else { return }
        
        let vcHeight: CGFloat = vc.view.bounds.height
        let dragAmount: CGFloat = (presentViewController == nil) ? vcHeight : -vcHeight
        var progress: CGFloat = translation.y / dragAmount
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        switch pan.state {
        case .began:

            self.hasStarted = true
            vc.dismiss(animated: true, completion: nil)
        case .changed:
            guard let lastProgress = lastProgress else {return}
            self.shouldFinish = lastProgress > percentThreshold
            update(progress)
        case .cancelled:
            self.hasStarted = false
            self.cancel()
        case .ended:
            completionSpeed = 0.1
            self.hasStarted = false
            self.shouldFinish ? self.finish() : self.cancel()
        default:
            self.cancel()
            self.hasStarted = false
            break
        }

        lastProgress = progress
    }
}
