//
//  UIColorButton.swift
//  SmartLife-App
//
//  Created by Hoang Nguyen on 3/1/18.
//  Copyright © 2018 thanhlt. All rights reserved.
//

import UIKit

class UIColorButton: UIButton {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.layer.cornerRadius = 5
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.backgroundColor = UIColor(red: 252, green: 107, blue: 42).cgColor
        self.titleLabel?.font =  UIFont(name: "YuGothic-Bold", size: 15 * GlobalMethod.displayScale)
    }

}
