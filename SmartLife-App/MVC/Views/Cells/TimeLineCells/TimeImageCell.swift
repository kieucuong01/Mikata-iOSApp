//
//  TimeImageCell.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/28/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class TimeImageCell: UICollectionViewCell {
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        let scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        widthConstraint.constant = 140 * scale
    }
    
}
