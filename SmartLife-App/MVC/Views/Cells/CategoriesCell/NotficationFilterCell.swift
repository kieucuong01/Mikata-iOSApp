//
//  NotficationFilterCell.swift
//  SmartLife-App
//
//  Created by thanhlt on 9/12/17.
//  Copyright © 2017 thanhlt. All rights reserved.
//

import UIKit

class NotficationFilterCell: UITableViewCell {

    @IBOutlet weak var mLastLineView: UIView!
    @IBOutlet weak var mLabelContent: UILabel!
    @IBOutlet weak var mButtonCheck: UIButton!
    
    @IBOutlet weak var mLeadingConstraintLabelContent: NSLayoutConstraint!
    
    var scale: CGFloat = DISPLAY_SCALE
    override func awakeFromNib() {
        super.awakeFromNib()
        scale = IS_IPAD ? DISPLAY_SCALE_IPAD : DISPLAY_SCALE
        // Initialization code
        self.mLeadingConstraintLabelContent.constant = 18 * scale
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
