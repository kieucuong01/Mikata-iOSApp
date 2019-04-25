//
//  ByteDetailTopCell.swift
//  SmartLife-App
//
//  Created by DELL7447 on 10/2/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class ByteDetailTopCell: UITableViewCell {

    /*Set constraint variable*/
    @IBOutlet weak var mTopConstraintLabelTitleByte: NSLayoutConstraint!
    @IBOutlet weak var mTopConstraintIconCurrency: NSLayoutConstraint!
    
    @IBOutlet weak var mLeadingLabelCurrency: NSLayoutConstraint!
    @IBOutlet weak var mLeadingIconTime: NSLayoutConstraint!
    @IBOutlet weak var mLeadingLabelTime: NSLayoutConstraint!
    
    @IBOutlet weak var mBottomLabelSkill: NSLayoutConstraint!
    @IBOutlet weak var mBottomLabelTipBottom: NSLayoutConstraint!
    @IBOutlet weak var mLabelTipBottom: UILabel!
    
    /*Variable allow change value*/
    @IBOutlet weak var mImageByte: UIImageView!
    @IBOutlet weak var mTitleByte: UILabel!
    @IBOutlet weak var mLabelCurrency: UILabel!
    @IBOutlet weak var mLabelTime: UILabel!
    @IBOutlet weak var mLabelBus: UILabel!
    @IBOutlet weak var mLabelSkill: UILabel!
    /*Variable allow change vaalue*/
    
    
    /* Private variable */
     var scale: CGFloat = DISPLAY_SCALE
    /* Private variable */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        // Initialization code
        self.setConstraintForViews()
        self.setFontForViews()
        self.setTitleForViews()
        self.setPropertyForViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Private method
    private func setConstraintForViews() {
        self.mTopConstraintLabelTitleByte.constant = 3 * scale
        self.mTopConstraintIconCurrency.constant = 9 * scale
        self.mLeadingLabelCurrency.constant = 4 * scale
        self.mLeadingIconTime.constant = 6 * scale
        self.mLeadingLabelTime.constant = 4 * scale
        self.mBottomLabelSkill.constant = 8 * scale
        self.mBottomLabelTipBottom.constant  = 10 * scale
    }
    
    private func setFontForViews() {
        self.mTitleByte.font = UIFont(name: self.mTitleByte.font.fontName, size: 15 * scale)
        
        self.mLabelTime.font = UIFont(name: self.mLabelTime.font.fontName, size: 10 * scale)
        self.mLabelBus.font = UIFont(name: self.mLabelBus.font.fontName, size: 10 * scale)
        self.mLabelSkill.font = UIFont(name: self.mLabelSkill.font.fontName, size: 10 * scale)
        self.mLabelCurrency.font = UIFont(name: self.mLabelCurrency.font.fontName, size: 10 * scale)
        self.mLabelTipBottom.font = UIFont(name: self.mLabelTipBottom.font.fontName, size: 10 * scale)
    }
    
    private func setTitleForViews() {
    
    }
    
    private func setPropertyForViews() {
    
    }
    
}

