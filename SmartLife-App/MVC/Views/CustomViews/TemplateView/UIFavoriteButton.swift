//
//  UIFavoriteButton.swift
//  SmartLife-App
//
//  Created by Hoang Nguyen on 4/24/18.
//  Copyright © 2018 thanhlt. All rights reserved.
//

import UIKit

class UIFavoriteButton: UIButton {


    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.layer.cornerRadius = 5
        self.setTitleColor(primaryColor, for: .normal)
        self.setTitleColor(UIColor.white, for: .selected)
        self.setImage(#imageLiteral(resourceName: "star_orange"), for: .normal)
        self.setImage(#imageLiteral(resourceName: "star_white"), for: .selected)
        self.setTitle(NSLocalizedString("timelineview_button_favorite", comment: ""), for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        self.imageEdgeInsets = UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0)
        self.titleLabel?.font =  UIFont(name: "YuGothic-Bold", size: 12 * GlobalMethod.displayScale)
        self.setBackgroundImage(#imageLiteral(resourceName: "img_border_off"), for: .normal)
        self.setBackgroundImage(#imageLiteral(resourceName: "img_border_on"), for: .selected)
    }
}
