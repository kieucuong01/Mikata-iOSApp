//
//  MenuMyPageCell.swift
//  SmartLife-App
//
//  Created by thanhlt on 8/21/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class MenuMyPageCell: UICollectionViewCell {
    
    @IBOutlet weak var mImageMenu: UIImageView!
    @IBOutlet weak var mLabelmenu: UILabel!
    @IBOutlet weak var mConstraintTopLabel: NSLayoutConstraint!
    
    private var scale:CGFloat = DISPLAY_SCALE
    
    override func awakeFromNib() {
         super.awakeFromNib()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.createSubviews()
        self.setConstraintForViews()
    }
    
    private func createSubviews() {
    }
    
    private func setConstraintForViews() {
        self.mConstraintTopLabel.constant = 51 * scale
        self.mLabelmenu.font = UIFont(name: self.mLabelmenu.font.fontName, size: 9.5 * scale)
    }
}

