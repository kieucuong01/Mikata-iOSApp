//
//  YSTypingAnimation.swift
//  
//
//  Created by Cem Olcay on 22/06/15.
//
//

import UIKit

struct YSTypingAnimationAppearance {
    var dotSize: CGFloat!
    var dotSpacing: CGFloat!
    var dotColor: UIColor!
    var dotCount: Int!
    var jumpHeight: CGFloat!
    var jumpDuration: TimeInterval!
    
    init () {
        dotSize = 4.0
        dotSpacing = 4.0
        dotColor = UIColor.lightGray
        dotCount = 3
        jumpHeight = 4.0
        jumpDuration = 0.25
    }
}

class YSTypingAnimation: UIView {

    // MARK: Properties
    
    var appearance: YSTypingAnimationAppearance = YSTypingAnimationAppearance()
    var dots: [UIView] = []
    var isRunning: Bool = false
    
    // MARK: Init
    
    init () {
        super.init(frame: CGRect(x: 10.0, y: 20.0, width: (CGFloat(appearance.dotCount) * appearance.dotSize) + (CGFloat(appearance.dotCount) * appearance.dotSpacing), height: appearance.dotSize + appearance.jumpHeight))
        
        var currentX: CGFloat = 0.0
        for _ in 0..<appearance.dotCount {
            let dot = drawDot()
            addSubview(dot)
            dots.append(dot)
            dot.frame.origin.x = currentX
            currentX += appearance.dotSize + appearance.dotSpacing
        }
    }
    
    required init? (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: Dot
    
    func drawDot () -> UIView {
        
        let dot = UIView (frame: CGRect(x: 0.0, y: 0.0, width: appearance.dotSize, height: appearance.dotSize))
        dot.backgroundColor = appearance.dotColor
        dot.layer.cornerRadius = appearance.dotSize/2.0
        
        return dot
    }
    
    
    // MARK: Animation
    
    var jumpAnim: CAAnimationGroup {
        get {
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = 1.5
            animationGroup.repeatCount = .infinity

            let easeOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

            let anim = CABasicAnimation(keyPath: "position.y")
            anim.fromValue = 0
            anim.toValue = -appearance.jumpHeight
            anim.duration = appearance.jumpDuration
            anim.autoreverses = true
            anim.timingFunction = easeOut

            animationGroup.animations = [anim]

            return animationGroup
        }
    }

    func startAnimating() {
        if self.isRunning == false {
            var del: TimeInterval = 0

            for dot in dots {
                delay(seconds: del, after: { () -> Void in
                    dot.layer.add(self.jumpAnim, forKey: "jump")
                })

                del = del + (appearance.jumpDuration / 2.0)
            }
        }
    }
    
    // MARK: Helpers
    
    func delay (seconds: Double, queue: DispatchQueue = DispatchQueue.main, after: @escaping () -> Void) {
        let deadlineTime = DispatchTime.now() + seconds
        queue.asyncAfter(deadline: deadlineTime) {
            after()
        }
    }
}
