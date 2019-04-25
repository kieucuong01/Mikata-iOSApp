//
//  LoadingView.swift
//  SmartLife-App
//
//  Created by Hoang Nguyen on 3/19/18.
//  Copyright © 2018 thanhlt. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable public class LoadingView: UIView {
    fileprivate var shapeLayer = CAShapeLayer()
    fileprivate var animating = false

    @IBInspectable public var duration: CGFloat = 1.0
    @IBInspectable public var color: UIColor = GlobalMethod.hexStringToUIColor(hex: "#FC6B2A")

    public var isAnimating: Bool {
        return animating
    }

    @IBInspectable public var hidesWhenStopped: Bool = false

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public init(frame: CGRect, lineWidth: CGFloat, duration: CGFloat) {
        super.init(frame: frame)
        self.frame = frame
        self.duration = duration
        shapeLayer.frame = frame
        shapeLayer.lineWidth = lineWidth
        setup()
    }

    fileprivate func setup() {
        self.backgroundColor = UIColor.clear
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 1
        shapeLayer.lineWidth = 3

        isHidden = true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let center = CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
        let radius = min(self.bounds.size.width, self.bounds.size.height)/2.0 - self.shapeLayer.lineWidth / 2.0

        let bezierPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 1.85 * .pi, clockwise: true)

        shapeLayer.path = bezierPath.cgPath
        shapeLayer.frame = self.bounds

        isHidden = hidesWhenStopped

        self.layer.addSublayer(shapeLayer)
    }

    fileprivate func animateRotation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = .pi * 2.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = Float.infinity

        return animation
    }

    fileprivate func animateGroup() {
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animateRotation()]
        animationGroup.duration = CFTimeInterval(duration)
        animationGroup.fillMode = kCAFillModeBoth
        animationGroup.isRemovedOnCompletion = false
        animationGroup.repeatCount = Float.infinity

        shapeLayer.add(animationGroup, forKey: "loading")
    }

    public func startAnimating() {
        animating = true
        isHidden = false
        animateGroup()
    }

    public func stopAnimating() {
        animating = false
        isHidden = hidesWhenStopped
        shapeLayer.removeAllAnimations()
    }
}
