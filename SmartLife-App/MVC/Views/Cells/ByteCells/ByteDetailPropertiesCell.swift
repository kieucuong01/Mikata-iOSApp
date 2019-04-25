//
//  ByteDetailPropertiesCell.swift
//  SmartLife-App
//
//  Created by DELL7447 on 10/3/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class ByteDetailPropertiesCell: UITableViewCell {
    @IBOutlet weak var mLeadingLabelTitle: NSLayoutConstraint!
    @IBOutlet weak var mTopLabelTitle: NSLayoutConstraint!
    
    /*Avariable allow change value*/
    
    @IBOutlet weak var mTopLabelContent: NSLayoutConstraint!
    
    @IBOutlet weak var mLabelTitle: UILabel!
    @IBOutlet weak var mLabelConstant: UILabel!
    
    //View create shadow for bottom label content
    @IBOutlet weak var mViewShadow: UIView!
    /*Avariable allow change value*/
    var scale: CGFloat = DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        // Initialization code
        
        self.setConstraintForViews()
        self.setPropertiesForViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setConstraintForViews() {
        self.mLeadingLabelTitle.constant = 10 * scale
        self.mTopLabelContent.constant = 6 * scale
        
        //When title is empty should set is 0
        self.mTopLabelTitle.constant = 6 * scale
        
    }
    
    private func setPropertiesForViews() {
        self.mViewShadow.layer.shadowColor = UIColor.white.cgColor
        self.mViewShadow.layer.shadowOpacity = 3
        
    }
}
