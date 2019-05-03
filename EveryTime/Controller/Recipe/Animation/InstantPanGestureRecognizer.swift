//
//  InstantPanGestureRecognizer.swift
//  EveryTime
//
//  Created by Mark Wong on 30/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

// this creates conflict with the uitableview (recipe options) touch and this pan gesture
class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizer.State.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizer.State.began
    }
}
