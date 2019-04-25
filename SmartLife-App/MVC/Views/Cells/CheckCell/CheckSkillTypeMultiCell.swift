//
//  CheckSkillTypeMultiCell.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/9/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class CheckSkillTypeMultiCell: UICollectionViewCell {
    
    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var mImageCheckBox: UIImageView!
    private var scale:CGFloat  = DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.setFontForViews()
        self.setConstraintForViews()
    }
    
    private func setFontForViews() {
        mLabelTitle.font = UIFont(name: "YuGothic-Bold", size: 10 * scale)
    }
    
    private func setConstraintForViews() {
    
    }
}
