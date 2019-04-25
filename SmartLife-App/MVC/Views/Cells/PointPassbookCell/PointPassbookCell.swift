//
//  PointPassbookCell.swift
//  SmartLife-App
//
//  Created by DELL7447 on 10/4/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class PointPassbookCell: UITableViewCell {
    
    @IBOutlet weak var mHeightLabelContent: NSLayoutConstraint!
    @IBOutlet weak var mLabelDate: UILabel!
    @IBOutlet weak var mLabelContent: UILabel!
    @IBOutlet weak var mLabelBalancesOfPayment: UILabel!
    @IBOutlet weak var mLabelBalance: UILabel!
    
    var scale : CGFloat = DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        self.setFontForViews()
        
        self.mHeightLabelContent.constant = 10 * scale
    }
    
    
    private func setFontForViews() {
        self.mLabelDate.font = UIFont(name: self.mLabelDate.font.fontName, size: 10 * scale)
        self.mLabelContent.font = UIFont(name: self.mLabelContent.font.fontName, size: 10 * scale)
        self.mLabelBalancesOfPayment.font = UIFont(name: self.mLabelBalancesOfPayment.font.fontName, size: 11 * scale)
        self.mLabelBalance.font = UIFont(name: self.mLabelBalance.font.fontName, size: 11 * scale)
    }
}

