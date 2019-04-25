//
//  UIShadowView.swift
//  SmartLife-App
//
//  Created by Hoang Nguyen on 3/5/18.
//  Copyright © 2018 thanhlt. All rights reserved.
//

import UIKit

class UIShadowView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 0.0
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
