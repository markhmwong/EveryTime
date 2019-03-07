//
//  HorizontalTransitionInteractor.swift
//  SimpleRecipeTimer
//
//  Created by Mark Wong on 20/1/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class HorizontalTransitionInteractor: UIPercentDrivenInteractiveTransition {
    var generalViewController: UIViewController? = nil
    var enabled = false
    
    private let edgePanGesture = UIScreenEdgePanGestureRecognizer()
    
    init(viewController: UIViewController) {
        super.init()
        self.generalViewController = viewController
        edgePanGesture.addTarget(self, action: #selector(didEdgePanViewController(with:)))
        edgePanGesture.edges = .left
        edgePanGesture.cancelsTouchesInView = false
        viewController.view.addGestureRecognizer(edgePanGesture)
    }
}

private extension HorizontalTransitionInteractor {
    @objc func didEdgePanViewController(with recognizer: UIScreenEdgePanGestureRecognizer) {
        guard let vc = generalViewController else {
            return
        }
        
        let translation = recognizer.translation(in: vc.view)
        let percentage = translation.x / vc.view.frame.size.width
        
        switch recognizer.state {
        case .began:
            enabled = true
            vc.dismiss(animated: true, completion: nil)
            break
        case .changed:
            update(percentage)
            break
        case .ended:
            completionSpeed = 0.3
            if percentage > 0.5 {
                finish()
            } else {
                cancel()
            }
            enabled = false
            break
        case .cancelled:
            cancel()
            enabled = false
            break
        default:
            cancel()
            enabled = false
            break
        }
    }
}
