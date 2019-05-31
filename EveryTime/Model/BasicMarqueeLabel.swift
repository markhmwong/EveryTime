//
//  BasicMarqueeLabel.swift
//  EveryTime
//
//  Created by Mark Wong on 7/4/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct MarqueeLabelAnimation {
    let averageSpeed: CGFloat = 50.128205128205124
    
    var animationDuration: TimeInterval
    
    var endXPos: CGFloat
    
    var startXPos: CGFloat
    
    var frame: CGRect
    
    var padding: CGFloat = 20.0
    
    init(frame: CGRect, screenWidth: CGFloat) {
        self.frame = frame
        endXPos = (self.frame.minX + self.frame.maxX) - screenWidth + padding
        startXPos = self.frame.minX
        animationDuration = TimeInterval(self.endXPos / self.averageSpeed)
    }
    
}

class BasicMarqueeLabel: UILabel {
    
    var animationProperties : MarqueeLabelAnimation?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareAnimationProperties() {
        animationProperties = MarqueeLabelAnimation(frame: frame, screenWidth: UIScreen.main.bounds.width)
    }

    func applyAnimation() {
        guard animationProperties != nil else {
//            print("must prepare animation properties")
            return
        }
//        UIView.animateKeyframes(withDuration: ap.animationDuration, delay: 1.5, options: [.calculationModeCubicPaced, .autoreverse, .repeat], animations: {
//            UIView.addKeyframe(withRelativeStartTime: 0.0 / ap.animationDuration, relativeDuration: (ap.animationDuration * 0.9) / ap.animationDuration, animations: {
//                self.transform = CGAffineTransform(translationX: -ap.endXPos, y: 0.0)
//            })
//
//            UIView.addKeyframe(withRelativeStartTime: (ap.animationDuration * 0.9) / ap.animationDuration, relativeDuration: 1 - ((ap.animationDuration * 0.9) / ap.animationDuration), animations: {
//                self.transform = CGAffineTransform(translationX: -ap.endXPos, y: 0.0)
//            })
//
//        }, completion: nil)
    }
}
