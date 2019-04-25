//
//  TagCell.swift
//  SmartLife-App
//
//  Created by DELL7447 on 10/10/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {

    @IBOutlet weak var mLabelTag: UILabel!
    var scale = DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.setFontForViews()
    }

    private func setFontForViews() {
        self.mLabelTag.font = UIFont(name: self.mLabelTag.font.fontName, size: 8 * scale)
    }
}
