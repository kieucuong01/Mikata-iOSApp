//
//  HeaderCheckSkillView.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/4/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class HeaderCheckSkillView: UIView {

    @IBOutlet weak var mLeadingLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var mLabelTitle: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private var scale: CGFloat = DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.setConstraintForViews()
        self.setFontForViews()
    }
    
    private func setConstraintForViews() {
        self.mLeadingLabelConstraint.constant = 14 * scale
     }
    
    private func setFontForViews() {
        self.mLabelTitle.font = UIFont.systemFont(ofSize: 12 * scale)
    }
}
